//
//  User.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

struct User: Identifiable {
    let id: String
    var username: String
    var email: String
    var password: String
    var iconColour: Color
    var chats: [Chat] = []
    
    func getPassword() -> String {
        return "**********"
    }
    
    mutating func updateUsername(newUsername: String) {
        username = newUsername
    }
    
    mutating func updateEmail(newEmail: String) {
        email = newEmail
    }
    
    mutating func updatePassword(newPassword: String) {
        password = newPassword
    }
    
    mutating func createChat(otherUser: User) {
        let chat = Chat(id: UUID().uuidString, otherUser: otherUser)
        chats.append(chat)
    }
    
    func sendMessage(chatId: String, messageContent: String) {
        let filteredChats = chats.filter { chat in
            return chat.id == chatId
        }
        
        if !filteredChats.isEmpty {
            var foundChat = filteredChats[0] // chat potentially needs to be a class to allow this edit to occur
            let message = Message(id: UUID().uuidString, content: messageContent, sent: true, timestamp: Date.now)
            foundChat.sendMessage(message: message)
        }
    }
}
