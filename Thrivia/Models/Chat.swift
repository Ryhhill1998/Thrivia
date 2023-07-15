//
//  Chat.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import Foundation

struct Chat: Identifiable {
    let id: String
    let otherUser: User
    var messages: [Message] = []
    
    mutating func sendMessage(message: Message) {
        messages.append(message)
    }
    
    mutating func receiveMessage(message: Message) {
        messages.append(message)
    }
}
