//
//  ChatModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class ChatsModel {
    func getActiveUsers(userId: String) -> [OtherUser] {
        // search db for all active user docs with id != userId
        let otherUser1 = OtherUser(id: "2", username: "CoolCucumber8080", iconColour: Color(uiColor: UIColor(red: 0.14, green: 0.50, blue: 0.70, alpha: 1.00)))
        let otherUser2 = OtherUser(id: "3", username: "BoxingGiraffe99", iconColour: Color(uiColor: UIColor(red: 0.13, green: 0.57, blue: 0.31, alpha: 1.00)))
        
        // return array of OtherUser objects
        return [otherUser1, otherUser2]
    }
    
    private func getUser(userId: String) -> User {
        // search db for user doc with ID == userId
        return User(id: "2", username: "CoolCucumber8080", email: "CoolCucumber8080@outlook.com", iconColour: Color(uiColor: UIColor(red: 0.14, green: 0.50, blue: 0.70, alpha: 1.00)))
    }
    
    func getUserChats(userId: String) -> [Chat] {
        var userChats: [Chat] = []
        
        // search db for all chat docs with userId in userIds array
        // chat doc form: id, userIds, messageIds
        
        // for each chat doc, get user doc for other user
        // user doc form: id, email, username, iconColour
        var chatId = "1"
        var otherUserId = "2"
        // get User object from db
        var user = getUser(userId: otherUserId)
        var otherUserUsername = user.username
        var otherUserIconColour = user.iconColour

        // create chat object
        var chat = createChatObjectFromChatDoc(chatId: chatId, otherUserId: otherUserId, otherUserUsername: otherUserUsername, otherUserIconColour: otherUserIconColour)
        
        // add chat object to userChats array
        userChats.append(chat)
        
        // do this for next chat doc
        chatId = "2"
        otherUserId = "3"
        user = getUser(userId: otherUserId)
        otherUserUsername = "BoxingGiraffe99"
        otherUserIconColour = Color(uiColor: UIColor(red: 0.13, green: 0.57, blue: 0.31, alpha: 1.00))
        
        // create chat object
        chat = createChatObjectFromChatDoc(chatId: chatId, otherUserId: otherUserId, otherUserUsername: otherUserUsername, otherUserIconColour: otherUserIconColour)
        
        // add chat object to userChats array
        userChats.append(chat)
        
        // return userChats array
        return userChats
    }
    
    private func createChatObjectFromChatDoc(chatId: String, otherUserId: String, otherUserUsername: String, otherUserIconColour: Color) -> Chat {
        // convert data from user docs to OtherUser objects
        let otherUser = OtherUser(id: otherUserId, username: otherUserUsername, iconColour: otherUserIconColour)
        
        // for each chat doc, get message doc for each messageId
        var messages: [Message] = []
        
        // message doc form: id, content, senderId, timestamp
        var messageId = "1"
        var messageContent = "Hello there! What is your favourite colour?"
        var sent = true
        var timestamp = Date.now
        var message = Message(id: messageId, content: messageContent, sent: sent, timestamp: timestamp)
        // add to messages array
        messages.append(message)
        
        messageId = "2"
        messageContent = "Hi! My favourite colour is blue"
        sent = false
        timestamp = Date.now
        message = Message(id: messageId, content: messageContent, sent: sent, timestamp: timestamp)
        // add to messages array
        messages.append(message)
        
        messageId = "3"
        messageContent = "That's my favourite colour too!"
        sent = true
        timestamp = Date.now
        message = Message(id: messageId, content: messageContent, sent: sent, timestamp: timestamp)
        // add to messages array
        messages.append(message)
        
        // create Chat object and add to userChats array
        return Chat(id: chatId, otherUser: otherUser, messages: messages)
    }
    
    func getChat(userId: String, otherUser: OtherUser) -> Chat {
        // search db for chat doc containing both userId and otherUserId in userIds array
        // user doc form: id, email, username, iconColour
        let otherUserId = otherUser.id
        
        let chatId = getChatDoc(userId: userId, otherUserId: otherUserId)
        
        guard let unwrappedChatId = chatId else {
            // create new chat doc if doc does not exist in db
            let newChatId = createChatDoc(userId: userId, otherUserId: otherUserId)
            return Chat(id: newChatId, otherUser: otherUser, messages: [])
        }
        
        return createChatObjectFromChatDoc(chatId: unwrappedChatId, otherUserId: otherUserId, otherUserUsername: otherUser.username, otherUserIconColour: otherUser.iconColour)
    }
    
    private func getChatDoc(userId: String, otherUserId: String) -> String? {
        // search db for chat doc containing both userId and otherUserId in userIds array
        let chatExists = Bool.random()
        
        let chatId = chatExists ? "1" : nil
        
        return chatId
    }
    
    private func createChatDoc(userId: String, otherUserId: String) -> String {
        // create chat doc in db and return chat ID
        return "1"
    }
}
