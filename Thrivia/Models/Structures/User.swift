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
    
    mutating func getChat(otherUser: User) -> Chat {
        let filteredChats = chats.filter { chat in
            return chat.otherUser.id == otherUser.id
        }
        
        if filteredChats.isEmpty {
            return createChat(otherUser: otherUser)
        } else {
            return filteredChats[0]
        }
    }
    
    mutating func createChat(otherUser: User) -> Chat {
        let chat = Chat(id: UUID().uuidString, otherUser: otherUser)
        chats.append(chat)
        return chat
    }
}
