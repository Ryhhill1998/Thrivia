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
                                    
                                    var numberOfUnreadMessages = 0
                                    
                                    // initialise messages dispatch group
                                    let messagesDispatchGroup = DispatchGroup()
                                    
                                    if let messageIds = chatData["messageIds"] as? [String] {
                                        // get message data
                                        for messageId in messageIds {
                                            let docRef = self.db.collection("messages").document(messageId)
                                            
                                            messagesDispatchGroup.enter()
                                            
                                            docRef.getDocument { (document, error) in
                                                if self.createEncryptedMessageObjectFromDocument(document: document, userId: userId) != nil {
                                                    numberOfUnreadMessages += 1
                                                }
                                                
                                                messagesDispatchGroup.leave()
                                            }
                                        }
                                    }
                                    
                                    messagesDispatchGroup.notify(queue: .main) {
                                        // retrieve stored conversation
                                        let conversation = self.retrieveConversationFromUserDefaults(chatId: chatId)
                                        
                                        // initialise empty messages array
                                        var messages: [Message] = conversation?.messages ?? []
                                        
                                        for _ in 0..<numberOfUnreadMessages {
                                            messages.append(Message(id: UUID().uuidString, content: "\(numberOfUnreadMessages) new messages", sent: false, timestamp: Date.now))
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
    }
    
    func loadChat(chatId: String, otherUser: OtherUser, chatSetter: @escaping (Chat, Bool) -> Void) {
        if let conversation = retrieveConversationFromUserDefaults(chatId: chatId) {
            let messages = conversation.messages
            let chat = Chat(id: chatId, otherUser: otherUser, messages: messages)
            chatSetter(chat, true)
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
    
    func listenToChat(chatId: String, userId: String, messagesSetter: @escaping ([Message]) -> Void) {
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
                        var conversation: Conversation? = nil
                        
                        if let retrievedConversation = self.retrieveConversationFromUserDefaults(chatId: chatId) {
                            conversation = retrievedConversation
                            self.decryptAndSetMessages(chatId: chatId, data: data, userId: userId, conversation: conversation, messagesSetter: messagesSetter)
                        } else {
                            if let cryptoUser = self.retrieveCryptoUserFromUserDefaults(),
                               let prekeyBundle = self.getPrekeyBundleFromDocument(document: document) {
                                // delete one time prekey from DB
                                docRef.updateData([
                                    "oneTimePrekeys": FieldValue.arrayRemove([prekeyBundle["oneTimePrekey"]!])
                                ])
                                
                                let codableCryptoOtherUser = CodableCryptoOtherUser(prekeyBundle: prekeyBundle)
                                let cryptoOtherUser = CryptoOtherUser(codableCryptoOtherUser: codableCryptoOtherUser)
                                conversation = Conversation(user: cryptoUser, otherUser: cryptoOtherUser)
                                self.decryptAndSetMessages(chatId: chatId, data: data, userId: userId, conversation: conversation, messagesSetter: messagesSetter)
                            }
                        }
                    }
                }
            }
    }
    
    func decryptAndSetMessages(chatId: String, data: [String : Any], userId: String, conversation: Conversation?, messagesSetter: @escaping ([Message]) -> Void) {
        // initialise empty messages array
        var encryptedMessages: [EncryptedMessage] = []
        
        // initialise messages dispatch group
        let messagesDispatchGroup = DispatchGroup()
        
        if let messageIds = data["messageIds"] as? [String] {
            // get message data
            for messageId in messageIds {
                let docRef = self.db.collection("messages").document(messageId)
                
                messagesDispatchGroup.enter()
                
                docRef.getDocument { (document, error) in
                    if let encryptedMessage = self.createEncryptedMessageObjectFromDocument(document: document, userId: userId) {
                        encryptedMessages.append(encryptedMessage)
                    }
                    
                    messagesDispatchGroup.leave()
                }
            }
        }
        
        messagesDispatchGroup.notify(queue: .main) {
            // decrypt messages
            var decryptedMessages: [Message] = []
            
            if let conversation = conversation {
                for message in encryptedMessages {
                    // remove message doc from db
                    self.removeMessageDocFromDB(messageId: message.id)
                    
                    // remove message ID from chat doc
                    self.removeMessageIdFromChatDoc(chatId: chatId, messageId: message.id)
                    
                    conversation.receiveMessage(message: message)
                }
                
                decryptedMessages = conversation.messages
                self.saveConversationToUserDefaults(conversation: conversation, chatId: chatId)
            }
            
            // set messages
            messagesSetter(decryptedMessages)
        }
    }
    
    func removeMessageDocFromDB(messageId: String) {
        db.collection("messages").document(messageId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func removeMessageIdFromChatDoc(chatId: String, messageId: String) {
        let docRef = db.collection("chats").document(chatId)
        
        docRef.updateData([
            "messageIds": FieldValue.arrayRemove([messageId])
        ])
    }
    
    func saveConversationToUserDefaults(conversation: Conversation, chatId: String) {
        let defaults = UserDefaults.standard
        
        let codableConversation = CodableConversation(conversation: conversation)
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(codableConversation)

            // Write/Set Data
            defaults.set(data, forKey: chatId)
            
            print("Saved conversation locally")
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    func createEncryptedMessageObjectFromDocument(document: DocumentSnapshot?, userId: String) -> EncryptedMessage? {
        var encryptedMessage: EncryptedMessage? = nil
        
        if let messageDoc = document, messageDoc.exists {
            if let messageData = messageDoc.data() {
                if let senderId = messageData["senderId"] as? String {
                    if senderId != userId {
                        if let cipherText = messageData["cipherText"] as? String,
                           let identityKey = messageData["identityKey"] as? String,
                           let ephemeralKey = messageData["ephemeralKey"] as? String,
                           let oneTimePreKeyIdentifier = messageData["oneTimePreKeyIdentifier"] as? Int,
                           let sendChainLength = messageData["sendChainLength"] as? Int,
                           let previousSendChainLength = messageData["previousSendChainLength"] as? Int {
                            encryptedMessage = EncryptedMessage(id: messageDoc.documentID, cipherText: cipherText, identityKey: identityKey, ephemeralKey: ephemeralKey, oneTimePreKeyIdentifier: oneTimePreKeyIdentifier, sendChainLength: sendChainLength, previousSendChainLength: previousSendChainLength)
                        }
                    }
                }
            }
        }
        
        return encryptedMessage
    }
    
    func sendMessage(senderId: String, receiverId: String, content: String, chatId: String, messagesSetter: @escaping ([Message]) -> Void) {
        // get conversation data stored locally in user defaults
        var conversation: Conversation?
        
        if let storedConversation = retrieveConversationFromUserDefaults(chatId: chatId) {
            print("Retrieved conversation: \(storedConversation)")
            conversation = storedConversation
        }
        
        let receiverDocRef = db.collection("users").document(receiverId)
        
        receiverDocRef.getDocument { (document, error) in
            if conversation == nil {
                // get stored crypto user
                let cryptoUser = self.retrieveCryptoUserFromUserDefaults()
                
                // get prekey bundle from server
                if let cryptoUser = cryptoUser,
                   let prekeyBundle = self.getPrekeyBundleFromDocument(document: document) {
                    let codableCryptoOtherUser = CodableCryptoOtherUser(prekeyBundle: prekeyBundle)
                    let cryptoOtherUser = CryptoOtherUser(codableCryptoOtherUser: codableCryptoOtherUser)
                    conversation = Conversation(user: cryptoUser, otherUser: cryptoOtherUser)
                }
            }
            
            // create encrypted message using conversation object
            let encryptedMessage = conversation!.sendMessage(messageContent: content)
            
            // save conversation locally
            self.saveConversationToUserDefaults(conversation: conversation!, chatId: chatId)
            
            // create message doc
            self.createMessageDocInDB(senderId: senderId, chatId: chatId, encryptedMessage: encryptedMessage)
            
            messagesSetter(conversation!.messages)
        }
    }
    
    private func createMessageDocInDB(senderId: String, chatId: String, encryptedMessage: EncryptedMessage) {
        db.collection("messages").document(encryptedMessage.id).setData([
            "senderId": senderId,
            "cipherText": encryptedMessage.cipherText,
            "identityKey": encryptedMessage.identityKey,
            "ephemeralKey": encryptedMessage.ephemeralKey,
            "oneTimePreKeyIdentifier": encryptedMessage.oneTimePreKeyIdentifier,
            "sendChainLength": encryptedMessage.sendChainLength,
            "previousSendChainLength": encryptedMessage.previousSendChainLength,
            "timestamp": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                // add message id to chat doc
                self.addMessageIdToChatDoc(chatId: chatId, messageId: encryptedMessage.id)
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
    
    private func retrieveCryptoUserFromUserDefaults() -> CryptoUser? {
        var cryptoUser: CryptoUser?
        
        let defaults = UserDefaults.standard
        var codableCryptoUser: CodableCryptoUser?
        
        if let codableCryptoUserData = defaults.data(forKey: "codableCryptoUser") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                codableCryptoUser = try decoder.decode(CodableCryptoUser.self, from: codableCryptoUserData)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        
        if let retrievedCodableCryptoUser = codableCryptoUser {
            cryptoUser = CryptoUser(codableCryptoUser: retrievedCodableCryptoUser)
        }
        
        return cryptoUser
    }
    
    private func retrieveConversationFromUserDefaults(chatId: String) -> Conversation? {
        var conversation: Conversation?
        
        let defaults = UserDefaults.standard
        var codableConversation: CodableConversation?
        
        if let conversationData = defaults.data(forKey: chatId) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                codableConversation = try decoder.decode(CodableConversation.self, from: conversationData)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        
        if let retrievedConversation = codableConversation {
            let previouslyReceivedEphemeralKeys = defaults.array(forKey: "previouslyReceivedEphemeralKeys-\(chatId)") as? [Data]
            let storedMessageKeys = defaults.array(forKey: "storedMessageKeys-\(chatId)") as? [StoredKey] ?? []
            let setOfPreviouslyReceivedEphemeralKeys = Set(previouslyReceivedEphemeralKeys ?? [])
            
            conversation = Conversation(codableConversation: retrievedConversation, previouslyReceivedEphemeralKeys: setOfPreviouslyReceivedEphemeralKeys, storedMessageKeys: storedMessageKeys)
        }
        
        return conversation
    }
    
    private func getPrekeyBundleFromDocument(document: DocumentSnapshot?) -> [String: String]? {
        var prekeyBundle: [String: String] = [:]
        
        if let document = document, document.exists {
            if let data = document.data() {
                if let identityKey = data["identityKey"] as? String,
                   let signedPrekey = data["signedPrekey"] as? String,
                   let signedPrekeySigning = data["signedPrekeySigning"] as? String,
                   let signedPrekeySignature = data["signedPrekeySignature"] as? String,
                   let oneTimePrekeys = data["oneTimePrekeys"] as? [String] {
                    let prekeyIdentifier = Int.random(in: 0..<oneTimePrekeys.count)
                    let oneTimePrekey = oneTimePrekeys[prekeyIdentifier]
                    
                    prekeyBundle.updateValue(document.documentID, forKey: "id")
                    prekeyBundle.updateValue(identityKey, forKey: "identityKey")
                    prekeyBundle.updateValue(signedPrekey, forKey: "signedPrekey")
                    prekeyBundle.updateValue(signedPrekeySigning, forKey: "signedPrekeySigning")
                    prekeyBundle.updateValue(signedPrekeySignature, forKey: "signedPrekeySignature")
                    prekeyBundle.updateValue(oneTimePrekey, forKey: "oneTimePrekey")
                    prekeyBundle.updateValue("\(prekeyIdentifier)", forKey: "prekeyIdentifier")
                }
            }
        }
        
        return prekeyBundle.isEmpty ? nil : prekeyBundle
    }
}
