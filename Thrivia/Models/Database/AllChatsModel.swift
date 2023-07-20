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
    
    func getActiveUsers(userId: String, activeUsersSetter: @escaping ([OtherUser]) -> Void) {
        var activeUsers: [OtherUser] = []
        
        // search db for all active user docs with id != userId
        db.collection("users").whereField("isActive", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        
                        if document.documentID == userId { continue }
                        
                        if let username = data["username"] as? String, let iconColour = data["iconColour"] as? String {
                            let otherUser = OtherUser(id: document.documentID, username: username, iconColour: Color(iconColour))
                            activeUsers.append(otherUser)
                        }
                    }
                    
                    activeUsersSetter(activeUsers)
                }
            }
    }
    
    func listenForChatUpdates(userId: String, userChatsSetter: @escaping ([Chat]) -> Void) {
        db.collection("chats").whereField("userIds", arrayContains: userId)
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
                        
                        let docRef = self.db.collection("users").document(otherUserId)
                        
                        chatsDispatchGroup.enter()
                        
                        docRef.getDocument { (document, error) in
                            if let otherUserDoc = document, otherUserDoc.exists {
                                let otherUserData = otherUserDoc.data()
                                if let otherUser = self.createOtherUserObjectFromData(otherUserId: otherUserId, data: otherUserData) {
                                    // initialise empty messages array
                                    var messages: [Message] = []
                                    
                                    // initialise messages dispatch group
                                    let messagesDispatchGroup = DispatchGroup()
                                    
                                    if let messageIds = chatData["messageIds"] as? [String] {
                                        // get message data
                                        for messageId in messageIds {
                                            let docRef = self.db.collection("messages").document(messageId)

                                            messagesDispatchGroup.enter()
                                            
                                            docRef.getDocument { (document, error) in
                                                if let messageDoc = document, messageDoc.exists {
                                                    let messageData = messageDoc.data()

                                                    if let message = self.createMessageObjectFromData(userId: userId, messageId: messageId, data: messageData) {
                                                        messages.append(message)
                                                        messagesDispatchGroup.leave()
                                                    }
                                                } else {
                                                    print("Document does not exist")
                                                }
                                            }
                                        }
                                    }
                                    
                                    messagesDispatchGroup.notify(queue: .main) {
                                        // sort messages
                                        messages.sort {
                                            $0.timestamp < $1.timestamp
                                        }
                                        let chat = Chat(id: chatId, otherUser: otherUser, messages: messages)
                                        userChats.append(chat)
                                        chatsDispatchGroup.leave()
                                    }
                                    
                                }
                            } else {
                                print("Document does not exist")
                            }
                        }
                    }
                }
                
                chatsDispatchGroup.notify(queue: .main) {
                    userChatsSetter(userChats)
                }
            }
    }
    
    func createNewChat(userId: String, otherUser: OtherUser, chatSetter: @escaping (Chat, Bool) -> Void) {
        let otherUserId = otherUser.id
        
        // create new chat doc
        // create counter doc in db
        var ref: DocumentReference? = nil
        
        ref = self.db.collection("chats").addDocument(data: [
            "userIds": [userId, otherUserId]
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                let chatId = ref!.documentID
                print("Document added with ID: \(chatId)")
                
                // add chatId to user and otherUser docs
                self.addChatIdToUserDoc(userId: userId, chatId: chatId)
                self.addChatIdToUserDoc(userId: otherUserId, chatId: chatId)
                
                // set chat
                let chat = Chat(id: chatId, otherUser: otherUser, messages: [])
                chatSetter(chat, true)
            }
        }
    }
    
    func listenToChat(chatId: String, userId: String, chatSetter: @escaping (Chat) -> Void) {
        db.collection("chats").document(chatId)
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
                
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
                
                let chatId = document.documentID
                
                if let userIds = data["userIds"] as? [String] {
                    // get other user data
                    let otherUserId = userIds[0] == userId ? userIds[1] : userIds[0]
                    
                    let docRef = self.db.collection("users").document(otherUserId)
                    
                    docRef.getDocument { (document, error) in
                        if let otherUserDoc = document, otherUserDoc.exists {
                            let otherUserData = otherUserDoc.data()
                            if let otherUser = self.createOtherUserObjectFromData(otherUserId: otherUserId, data: otherUserData) {
                                // initialise empty messages array
                                var messages: [Message] = []
                                
                                // initialise messages dispatch group
                                let messagesDispatchGroup = DispatchGroup()
                                
                                if let messageIds = data["messageIds"] as? [String] {
                                    // get message data
                                    for messageId in messageIds {
                                        let docRef = self.db.collection("messages").document(messageId)

                                        messagesDispatchGroup.enter()
                                        
                                        docRef.getDocument { (document, error) in
                                            if let messageDoc = document, messageDoc.exists {
                                                let messageData = messageDoc.data()

                                                if let message = self.createMessageObjectFromData(userId: userId, messageId: messageId, data: messageData) {
                                                    messages.append(message)
                                                    messagesDispatchGroup.leave()
                                                }
                                            } else {
                                                print("Document does not exist")
                                            }
                                        }
                                    }
                                }
                                
                                messagesDispatchGroup.notify(queue: .main) {
                                    // sort messages
                                    messages.sort {
                                        $0.timestamp < $1.timestamp
                                    }
                                    let chat = Chat(id: chatId, otherUser: otherUser, messages: messages)
                                    chatSetter(chat)
                                }
                                
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            }
    }
    
    func sendMessage(senderId: String, receiverId: String, content: String, chatId: String) {
        // create message doc in db
        var docRef: DocumentReference? = nil
        
        docRef = db.collection("messages").addDocument(data: [
            "senderId": senderId,
            "content": content,
            "timestamp": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                // add message id to chat doc
                if let messageId = docRef?.documentID {
                    self.addMessageIdToChatDoc(chatId: chatId, messageId: messageId)
                }
            }
        }
    }
    
    private func addMessageIdToChatDoc(chatId: String, messageId: String) {
        let chatDocRef = self.db.collection("chats").document(chatId)

        chatDocRef.updateData([
            "messageIds": FieldValue.arrayUnion([messageId])
        ])
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
    
    private func createMessageObjectFromData(userId: String, messageId: String, data: [String: Any]?) -> Message? {
        var message: Message?
        
        if let content = data?["content"] as? String,
           let senderId = data?["senderId"] as? String,
           let timestamp = (data?["timestamp"] as? Timestamp)?.dateValue() {
            message = Message(id: messageId, content: content, sent: senderId == userId, timestamp: timestamp)
        }
        
        return message
    }
    
    private func retrievePrekeyBundleForUser(userId: String) {
        // get conversation data stored locally in user defaults
        
        
        let docRef = db.collection("users").document(userId)

        docRef.getDocument { (document, error) in
            guard let prekeyBundle = self.getPrekeyBundleFromDocument(document: document) else { return }
            
            
        }
    }
    
    private func retrieveConversationDataFromUserDefaults(chatId: String) {
        let defaults = UserDefaults.standard
//        let conversationData = defaults.
        
        // previous ephemeral keys received to check if message is new or old chain
        var previouslyReceivedEphemeralKeys: Set<Data> = []
        
        // store message keys for missed messages
        var storedMessageKeys: [StoredKey] = []
    }
    
    private func getPrekeyBundleFromDocument(document: DocumentSnapshot?) -> [String: String]? {
        var prekeyBundle: [String: String] = [:]
        
        if let document = document, document.exists {
            if let data = document.data() {
                if let identityKey = data["identityKey"] as? String,
                let signedPrekey = data["signedPrekey"] as? String,
                let signedPrekeySignature = data["signedPrekeySignature"] as? String,
                let oneTimePrekeys = data["oneTimePrekeys"] as? [String] {
                    let oneTimePrekey = oneTimePrekeys.randomElement() ?? "none"
                    
                    prekeyBundle.updateValue(identityKey, forKey: "identityKey")
                    prekeyBundle.updateValue(signedPrekey, forKey: "signedPrekey")
                    prekeyBundle.updateValue(signedPrekeySignature, forKey: "signedPrekeySignature")
                    prekeyBundle.updateValue(oneTimePrekey, forKey: "oneTimePrekey")
                }
            }
        }
        
        return prekeyBundle.isEmpty ? nil : prekeyBundle
    }
}
