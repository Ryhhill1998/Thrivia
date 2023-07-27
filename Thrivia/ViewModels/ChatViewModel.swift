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
    var chatListener: ListenerRegistration?
    
    @Published var loadedChat: Chat?
    @Published var messages: [Message] = []
    @Published var lastMessageIndex = 0
    @Published var sendError = ""
    @Published var errorExists = false
    @Published var messageSent = false
    
    func setMessages(messages: [Message]) {
        self.messages = messages
        lastMessageIndex = self.messages.count - 1
    }
    
    func listenToChat() {
        if chatListener != nil {
            return
        }
        
        if let chatId = loadedChat?.id,
           let userId = userId {
            chatListener = allChatsModel.listenToChat(chatId: chatId, userId: userId, messagesSetter: setMessages(messages:))
        }
    }
    
    func sendMessage(content: String) {
        if content.isEmpty {
            setError(error: "Message cannot be empty.")
        } else {
            if let userId = userId,
               let chatId = loadedChat?.id,
               let otherUserId = loadedChat?.otherUser.id {
                allChatsModel.sendMessage(senderId: userId, receiverId: otherUserId, content: content, chatId: chatId, errorSetter: setError(error:)) {
                    self.setMessageSent(messageSent: true)
                }
            }
        }
    }
    
    func setMessageSent(messageSent: Bool) {
        self.messageSent = messageSent
    }
    
    func resetMessageSent() {
        setMessageSent(messageSent: false)
    }
    
    func setError(error: String) {
        sendError = error
        errorExists = true
    }
    
    func deleteMessages(messageIds: Set<String>) {
        if let chatId = loadedChat?.id {
            allChatsModel.deleteMessages(chatId: chatId, messageIds: messageIds, messagesSetter: setMessages(messages:))
        }
    }
    
    func removeListener() {
        chatListener?.remove()
    }
}
