//
//  ChatModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class ChatsModel {
    func getUserChats(user: User) -> [Chat] {
        let user = User(id: UUID().uuidString, username: "ZigzagZebra24", email: "zigzagzebra24@outlook.com", password: "12345678", iconColour: Color(uiColor: UIColor(red: 0.57, green: 0.13, blue: 0.50, alpha: 1.00)))
        
        return user.chats
    }
    
    func getChat(user: User, otherUser: User) -> Chat {
        let chats = getUserChats(user: user)
        
        let filteredChats = chats.filter { chat in
            return chat.otherUser.id == otherUser.id
        }
        
        if filteredChats.isEmpty {
            return createChat(user: user, otherUser: otherUser)
        } else {
            return filteredChats[0]
        }
    }
    
    func createChat(user: User, otherUser: User) -> Chat {
        var chats = getUserChats(user: user)
        
        let chat = Chat(id: UUID().uuidString, otherUser: otherUser)
        chats.append(chat)
        return chat
    }
    
    func createMessage(sender: User, content: String) -> Message {
        return Message(id: UUID().uuidString, content: content, sent: true, timestamp: Date.now)
    }
    
    func sendMessage(sender: User, receiver: User, messageContent: String) {
        var chat = getChat(user: sender, otherUser: receiver)
        let message = createMessage(sender: sender, content: messageContent)
        chat.sendMessage(message: message)
    }
}
