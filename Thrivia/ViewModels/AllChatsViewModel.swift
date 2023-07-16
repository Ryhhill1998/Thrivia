//
//  AllChatsViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class AllChatsViewModel: ObservableObject {
    var user: User
    var chatModel = ChatsModel()
    
    @Published var allChats: [Chat]
    
    init(user: User) {
        self.user = user
        allChats = chatModel.getUserChats(user: user)
    }
    
    func sendMessage(to otherUser: User, messageContent: String) {
        
    }
}
