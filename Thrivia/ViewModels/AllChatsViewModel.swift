//
//  AllChatsViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI
import Firebase

class AllChatsViewModel: ObservableObject {
    
    var allChatsModel = AllChatsModel()
    var userId: String?
    var activeUsersListener: ListenerRegistration?
    var allChatsListener: ListenerRegistration?
    
    @Published var activeUsers: [OtherUser] = []
    @Published var allChats: [Chat] = []
    @Published var loadedChat: Chat?
    @Published var chatIsLoaded = false
    
    func listenToActiveUsers() {
        if let userId = userId {
            allChatsModel.listenToActiveUsers(userId: userId, activeUsersSetter: setActiveUsers(activeUsers:)) { self.activeUsersListener = $0 }
        }
    }
    
    func listenToChats() {
        if let userId = userId {
            allChatsModel.listenForChatUpdates(userId: userId, userChatsSetter: setAllChats(allChats:)) { self.allChatsListener = $0 }
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
        
        print(allChats)
    }
    
    func getUserActivityStatus(userId: String) -> Bool {
        return activeUsers.contains { $0.id == userId }
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
        if let userId = userId {
            allChatsModel.retrieveChat(userId: userId, otherUser: otherUser, chatSetter: setLoadedChat(loadedChat:chatIsLoaded:))
        }
    }
    
    func removeListeners() {
        activeUsersListener?.remove()
        allChatsListener?.remove()
    }
}
