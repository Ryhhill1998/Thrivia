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
    
    var userId: String?
    var listenerCreated = false
    
    @Published var loadedChat: Chat?
    @Published var messages: [Message] = []
    @Published var lastMessageIndex = 0
    
    func setMessages(messages: [Message]) {
        self.messages = messages
        self.listenerCreated = true
        lastMessageIndex = self.messages.count - 1
    }
    
    func listenToChat() {
        if let chatId = loadedChat?.id,
           let userId = userId {
            allChatsModel.listenToChat(chatId: chatId, userId: userId, messagesSetter: setMessages(messages:))
        }
    }
    
    func sendMessage(content: String) {
        if let userId = userId,
           let chatId = loadedChat?.id,
           let otherUserId = loadedChat?.otherUser.id {
            allChatsModel.sendMessage(senderId: userId, receiverId: otherUserId, content: content, chatId: chatId)
        }
    }
}
