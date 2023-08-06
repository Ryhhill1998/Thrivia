//
//  ChatModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI
import FirebaseFirestore

class AllChatsModel {
    
    private let db = Firestore.firestore()
    
    func listenToActiveUsers(userId: String, activeUsersSetter: @escaping ([OtherUser]) -> Void, listenerSetter: @escaping (ListenerRegistration) -> Void) {
        // get user blocked IDs
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.getDocument { (document, error) in
            if let userDoc = document, userDoc.exists, let userData = userDoc.data() {
                let blockedUserIds = userData["blockedUserIds"] as? [String]
                let setOfBlockedUserIds: Set<String> = Set(blockedUserIds ?? [])
                
                let listener = self.db.collection("users")
                    .whereField("isActive", isEqualTo: true)
                    .addSnapshotListener { querySnapshot, error in
                        guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                        }
                        
                        if let error = error {
                            print("Error getting documents: \(error)")
                            return
                        }
                        
                        var activeUsers: [OtherUser] = []
                        
                        for document in documents {
                            // check if user is the signed in user
                            if document.documentID == userId {
                                continue
                            }
                            
                            let data = document.data()
                            
                            // check if signed in user has blocked this user
                            if setOfBlockedUserIds.contains(document.documentID) {
                                print("signed in user has blocked this user")
                                continue
                            }
                            
                            // check if this user has blocked the signed in user
                            if let otherUserBlockedIds = data["blockedUserIds"] as? [String] {
                                let setOfOtherUserBlockedIds: Set<String> = Set(otherUserBlockedIds)
                                
                                if setOfOtherUserBlockedIds.contains(userId) {
                                    print("this user has blocked the signed in user")
                                    continue
                                }
                            }
                            
                            if let username = data["username"] as? String,
                               let iconColour = data["iconColour"] as? String {
                                let otherUser = OtherUser(id: document.documentID, username: username, iconColour: Color(iconColour))
                                activeUsers.append(otherUser)
                            }
                        }
                        
                        activeUsersSetter(activeUsers)
                    }
                
                listenerSetter(listener)
            }
        }
    }
    
    func listenForChatUpdates(userId: String, userChatsSetter: @escaping ([Chat]) -> Void, listenerSetter: @escaping (ListenerRegistration) -> Void) {
        // get user blocked IDs
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.getDocument { (document, error) in
            if let userDoc = document, userDoc.exists, let userData = userDoc.data() {
                let blockedUserIds = userData["blockedUserIds"] as? [String]
                let setOfBlockedUserIds: Set<String> = Set(blockedUserIds ?? [])
                
                // listen to chats
                let listener = self.db.collection("chats").whereField("userIds", arrayContains: userId)
                    .addSnapshotListener { querySnapshot, error in
                        guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                        }
                        
                        // initialise user chats array
                        var userChats: [Chat] = []
                        
                        // initialise chats dispatch group
                        let chatsDispatchGroup = DispatchGroup()
                        
                        for chatDoc in documents {
                            let chatData = chatDoc.data()
                            let chatId = chatDoc.documentID
                            
                            if let userIds = chatData["userIds"] as? [String] {
                                // get other user data
                                let otherUserId = userIds[0] == userId ? userIds[1] : userIds[0]
                                
                                // check if signed in user has blocked this user
                                if setOfBlockedUserIds.contains(otherUserId) {
                                    continue
                                }
                                
                                let docRef = self.db.collection("users").document(otherUserId)
                                
                                chatsDispatchGroup.enter()
                                
                                docRef.getDocument { (document, error) in
                                    if let otherUserDoc = document, otherUserDoc.exists {
                                        let otherUserData = otherUserDoc.data()
                                        
                                        // check if this user has blocked the signed in user
                                        var userIsBlocked = false
                                        
                                        if let otherUserBlockedIds = otherUserData?["blockedUserIds"] as? [String] {
                                            let setOfOtherUserBlockedIds: Set<String> = Set(otherUserBlockedIds)
                                            
                                            if setOfOtherUserBlockedIds.contains(userId) {
                                                userIsBlocked = true
                                            }
                                        }
                                        
                                        if !userIsBlocked, let otherUser = self.createOtherUserObjectFromData(otherUserId: otherUserId, data: otherUserData) {
                                            
                                            var numberOfUnreadMessages = 0
                                            
                                            // initialise messages dispatch group
                                            let messagesDispatchGroup = DispatchGroup()
                                            
                                            if let messageIds = chatData["messageIds"] as? [String] {
                                                // get message data
                                                for messageId in messageIds {
                                                    let docRef = self.db.collection("messages").document(messageId)
                                                    
                                                    messagesDispatchGroup.enter()
                                                    
                                                    docRef.getDocument { (document, error) in
                                                        if let senderId = document?.data()?["senderId"] as? String, senderId != userId {
                                                            numberOfUnreadMessages += 1
                                                        }
                                                        
                                                        messagesDispatchGroup.leave()
                                                    }
                                                }
                                            }
                                            
                                            messagesDispatchGroup.notify(queue: .main) {
                                                let conversation = Utilities.retrieveConversationFromUserDefaults(chatId: chatId)
                                                
                                                // initialise empty messages array
                                                var messages: [Message] = conversation?.getMessages() ?? []
                                                
                                                if numberOfUnreadMessages > 0 {
                                                    messages.append(Message(id: UUID().uuidString, content: "\(numberOfUnreadMessages) new message\(numberOfUnreadMessages > 1 ? "s" : "")", sent: false, read: false, timestamp: Date.now))
                                                }
                                                
                                                let chat = Chat(id: chatId, otherUser: otherUser, messages: messages)
                                                userChats.append(chat)
                                                chatsDispatchGroup.leave()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        chatsDispatchGroup.notify(queue: .main) {
                            userChatsSetter(userChats)
                        }
                    }
                
                listenerSetter(listener)
            }
        }
    }
    
    func retrieveChat(userId: String, otherUser: OtherUser, chatSetter: @escaping (Chat, Bool) -> Void) {
        let otherUserId = otherUser.id
        
        let chatId = AllChatsModel.generateChatId(userId: userId, otherUserId: otherUserId)
        
        let chatDocRef = db.collection("chats").document(chatId)
        
        chatDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            if let document = document, document.exists {
                let chat = Chat(id: chatId, otherUser: otherUser, messages: [])
                chatSetter(chat, true)
            } else {
                self.createNewChat(userId: userId, otherUser: otherUser, chatSetter: chatSetter)
            }
        }
    }
    
    private static func generateChatId(userId: String, otherUserId: String) -> String {
        let id1Numbers = userId.asciiValues
        let id2Numbers = otherUserId.asciiValues
        
        var averagedNumbers: [UInt8] = []
        
        for i in 0..<id1Numbers.count {
            let num1 = id1Numbers[i]
            let num2 = id2Numbers[i]
            
            averagedNumbers.append((num1 + num2) / 2)
        }
        
        return averagedNumbers.map( { String(UnicodeScalar(UInt8($0))) }).reduce("", +)
    }
    
    private func createNewChat(userId: String, otherUser: OtherUser, chatSetter: @escaping (Chat, Bool) -> Void) {
        let otherUserId = otherUser.id
        
        let chatId = AllChatsModel.generateChatId(userId: userId, otherUserId: otherUserId)
        
        // create new chat doc
        self.db.collection("chats").document(chatId).setData([
            "userIds": [userId, otherUserId]
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                // add chatId to user and otherUser docs
                self.addChatIdToUserDoc(userId: userId, chatId: chatId)
                self.addChatIdToUserDoc(userId: otherUserId, chatId: chatId)
                
                // set chat
                let chat = Chat(id: chatId, otherUser: otherUser, messages: [])
                chatSetter(chat, true)
            }
        }
    }
    
    private func addChatIdToUserDoc(userId: String, chatId: String) {
        let userDocRef = self.db.collection("users").document(userId)
        
        userDocRef.updateData([
            "chatIds": FieldValue.arrayUnion([chatId])
        ])
    }
    
    private func createOtherUserObjectFromData(otherUserId: String, data: [String: Any]?) -> OtherUser? {
        var otherUser: OtherUser?
        
        if let username = data?["username"] as? String,
           let iconColour = data?["iconColour"] as? String {
            otherUser = OtherUser(id: otherUserId, username: username, iconColour: Color(iconColour))
        }
        
        return otherUser
    }
    
    func deleteChat(chatId: String) {
        if var conversation = Utilities.retrieveConversationFromUserDefaults(chatId: chatId) {
            conversation.resetMessages()
            
            if Utilities.saveConversationToUserDefaults(conversation: conversation, chatId: chatId) {
                print("Messages successfully cleared")
            } else {
                print("Failed to clear messages")
            }
        }
    }
}

extension StringProtocol {
    var asciiValues: [UInt8] { compactMap(\.asciiValue) }
}
