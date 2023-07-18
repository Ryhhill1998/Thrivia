//
//  ChatViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 18/07/2023.
//

import Foundation
import Firebase

class ChatViewModel: ObservableObject {
    var allChatsModel = AllChatsModel()
    
    let userId: String
    var listenerCreated = false
    @Published var loadedChat: Chat?
    
    init(userId: String, loadedChat: Chat?) {
        self.userId = userId
        self.loadedChat = loadedChat
        
        if !listenerCreated {
            listenToChat()
        }
    }
    
    func setLoadedChat(loadedChat: Chat) {
        self.loadedChat = loadedChat
        self.listenerCreated = true
    }
    
    func listenToChat() {
        if let chatId = loadedChat?.id {
            allChatsModel.listenToChat(chatId: chatId, userId: userId, chatSetter: setLoadedChat(loadedChat:))
        }
    }
    
    func sendMessage(content: String) {
        if let chatId = loadedChat?.id {
            allChatsModel.sendMessage(senderId: userId, content: content, chatId: chatId)
        }
    }
}
