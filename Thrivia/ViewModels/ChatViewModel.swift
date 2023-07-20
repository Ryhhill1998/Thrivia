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
    
    func setMessages(messages: [Message]) {
        self.loadedChat?.messages = messages
        self.listenerCreated = true
    }
    
    func listenToChat() {
        if let chatId = loadedChat?.id {
            allChatsModel.listenToChat(chatId: chatId, userId: userId, messagesSetter: setMessages(messages:))
        }
    }
    
    func sendMessage(content: String) {
        if let chatId = loadedChat?.id,
           let otherUserId = loadedChat?.otherUser.id {
            allChatsModel.sendMessage(senderId: userId, receiverId: otherUserId, content: content, chatId: chatId, messagesSetter: setMessages(messages:))
        }
    }
}
