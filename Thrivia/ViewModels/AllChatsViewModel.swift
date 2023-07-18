//
//  AllChatsViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class AllChatsViewModel: ObservableObject {
    var allChatsModel = AllChatsModel()
    var userId: String
    
    @Published var activeUsers: [OtherUser] = []
    @Published var allChats: [Chat] = []
    @Published var loadedChat: Chat?
    @Published var chatIsLoaded = false
    
    init(userId: String) {
        self.userId = userId
        
        if activeUsers.isEmpty {
            allChatsModel.getActiveUsers(userId: userId, activeUsersSetter: setActiveUsers(activeUsers:))
        }
        
        if allChats.isEmpty {
            allChatsModel.listenForChatUpdates(userId: userId, userChatsSetter: setAllChats(allChats:))
        }
    }
    
    func setActiveUsers(activeUsers: [OtherUser]) {
        self.activeUsers = activeUsers
    }
    
    func setAllChats(allChats: [Chat]) {
        self.allChats = allChats
    }
    
    func setLoadedChat(loadedChat: Chat, chatIsLoaded: Bool) {
        self.loadedChat = loadedChat
        self.chatIsLoaded = chatIsLoaded
    }
    
    func loadChat(otherUser: OtherUser) {
        if let foundChat = (allChats.filter { $0.otherUser.id == otherUser.id }).first {
            setLoadedChat(loadedChat: foundChat, chatIsLoaded: true)
        } else {
            allChatsModel.createNewChat(userId: userId, otherUser: otherUser, chatSetter: setLoadedChat(loadedChat:chatIsLoaded:))
        }
    }
}
