//
//  ChatModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI
import FirebaseFirestore

class ChatsModel {
    
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
    
    private func getUser(userId: String) -> User {
        // search db for user doc with ID == userId
        return User(id: "2", username: "CoolCucumber8080", email: "CoolCucumber8080@outlook.com", iconColour: Color("IconColour2"))
    }
    
    func getUserChats(userId: String, userChatsSetter: @escaping ([Chat]) -> Void) {
        // search db for all chat docs with userId in userIds array
        db.collection("chats").whereField("userIds", arrayContains: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    // initialise user chats array
                    var userChats: [Chat] = []
                    
                    // initialise chats dispatch group
                    let chatsDispatchGroup = DispatchGroup()
                    
                    for chatDoc in querySnapshot!.documents {
                        let chatData = chatDoc.data()
                        let chatId = chatDoc.documentID
                        
                        if let userIds = chatData["userIds"] as? [String], let messageIds = chatData["messageIds"] as? [String] {
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
    
}
