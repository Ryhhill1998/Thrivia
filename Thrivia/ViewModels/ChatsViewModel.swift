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
    
    @Published var allChats: [Chat]
    @Published var activeUsers: [OtherUser]
    @Published var loadedChat: Chat?
    
    init(userId: String) {
        self.userId = userId
        allChats = chatsModel.getUserChats(userId: userId)
        activeUsers = chatsModel.getActiveUsers(userId: userId)
    }
    
    func loadChat(otherUser: OtherUser) {
        loadedChat = chatsModel.getChat(userId: userId, otherUser: otherUser)
    }
    
    func sendMessage(content: String) {
        guard let chat = loadedChat else { return }
        
        let updatedChat = chatsModel.sendMessage(chat: chat, senderId: userId, content: content)
        loadedChat = updatedChat
    }
}
