//
//  Chat.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import Foundation

struct Chat: Identifiable {
    let id: String
    private let otherUser: OtherUser
    private var messages: [Message]
    
    init(id: String, otherUser: OtherUser, messages: [Message]) {
        self.id = id
        self.otherUser = otherUser
        self.messages = messages
    }
    
    func getOtherUser() -> OtherUser {
        return otherUser
    }
    
    func getMessages() -> [Message] {
        return messages
    }
    
    mutating func clearMessages() {
        messages = []
    }
    
    func getLastMessage() -> Message? {
        return messages.last
    }
}
