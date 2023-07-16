//
//  ChatModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class ChatsModel {
    func getUserChats(userId: String) -> [Chat] {
        // search db for user doc with id == userId
        
        let user = User(id: userId, username: "ZigzagZebra24", email: "zigzagzebra24@outlook.com", password: "12345678", iconColour: Color(uiColor: UIColor(red: 0.57, green: 0.13, blue: 0.50, alpha: 1.00)))
        
        return user.chats
    }
    
    func getChat(userId: String, otherUserId: String) -> Chat {
        // search db for chat containing both user IDs
        
        let chats = getUserChats(userId: userId)
        
        let filteredChats = chats.filter { chat in
            return chat.otherUser.id == otherUserId
        }
        
        if filteredChats.isEmpty {
            // create new chat doc in db if it does not already exist
            return createChat(userId: userId, otherUserId: otherUserId)
        } else {
            return filteredChats[0]
        }
    }
    
    func createChat(userId: String, otherUserId: String) -> Chat {
        // create chat doc in db
        
        var chats = getUserChats(userId: userId)
        let otherUser = User(id: userId, username: "CoolCucumber8080", email: "CoolCucumber8080@outlook.com", password: "12345678", iconColour: Color(uiColor: UIColor(red: 0.14, green: 0.50, blue: 0.70, alpha: 1.00)))
        
        let chat = Chat(id: UUID().uuidString, otherUser: otherUser)
        chats.append(chat)
        return chat
    }
    
    func createMessage(senderId: String, content: String) -> Message {
        // create message doc in db
        
        return Message(id: UUID().uuidString, content: content, sent: true, timestamp: Date.now)
    }
    
    func sendMessage(senderId: String, receiverId: String, messageContent: String) {
        var chat = getChat(userId: senderId, otherUserId: receiverId)
        let message = createMessage(senderId: senderId, content: messageContent)
        chat.sendMessage(message: message)
    }
}
