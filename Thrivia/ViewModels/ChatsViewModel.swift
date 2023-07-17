//
//  AllChatsViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class ChatsViewModel: ObservableObject {
    var chatsModel = ChatsModel()
    var userId: String
    
    @Published var activeUsers: [OtherUser] = []
    @Published var allChats: [Chat] = []
    @Published var loadedChat: Chat?
    
    init(userId: String) {
        self.userId = userId
        
        if activeUsers.isEmpty {
            chatsModel.getActiveUsers(userId: userId, activeUsersSetter: setActiveUsers(activeUsers:))
        }
        
        if allChats.isEmpty {
            chatsModel.getUserChats(userId: userId, userChatsSetter: setAllChats(allChats:))
        }
    }
    
    func setActiveUsers(activeUsers: [OtherUser]) {
        self.activeUsers = activeUsers
    }
    
    func setAllChats(allChats: [Chat]) {
        self.allChats = allChats
    }
    
    func loadChat(otherUser: OtherUser) {
    }
    
    func sendMessage(content: String) {
    }
}
