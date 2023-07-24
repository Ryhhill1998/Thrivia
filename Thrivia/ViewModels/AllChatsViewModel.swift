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
            allChatsModel.listenToActiveUsers(userId: userId, activeUsersSetter: setActiveUsers(activeUsers:))
        }
        
        // this needs to be fixed
        if allChats.isEmpty {
            allChatsModel.listenForChatUpdates(userId: userId, userChatsSetter: setAllChats(allChats:))
        }
    }
    
    func setActiveUsers(activeUsers: [OtherUser]) {
        self.activeUsers = activeUsers
    }
    
    func setAllChats(allChats: [Chat]) {
        self.allChats = allChats
        
        self.allChats.sort { chat1, chat2 in
            let date1 = chat1.messages.last?.timestamp ?? Date.now
            let date2 = chat2.messages.last?.timestamp ?? Date.now
            
            return date1 > date2
        }
    }
    
    func setLoadedChat(loadedChat: Chat, chatIsLoaded: Bool) {
        self.loadedChat = loadedChat
        self.chatIsLoaded = chatIsLoaded
    }
    
    func deleteChats(chatIds: Set<String>) {
        for chatId in chatIds {
            deleteChat(id: chatId)
        }
    }
    
    func deleteChat(id: String) {
        if var foundChat = (allChats.filter { $0.id == id }).first {
            foundChat.messages = []
            
            var updatedChats = allChats.filter { $0.id != id }
            updatedChats.append(foundChat)
            setAllChats(allChats: updatedChats)
        }
        
        allChatsModel.deleteChat(chatId: id)
    }
    
    func loadChat(otherUser: OtherUser) {
        allChatsModel.retrieveChat(userId: userId, otherUser: otherUser, chatSetter: setLoadedChat(loadedChat:chatIsLoaded:))
    }
}
