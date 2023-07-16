//
//  AllChatsViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class AllChatsViewModel: ObservableObject {
    var chatModel = ChatsModel()
    
    @Published var allChats: [Chat]
    
    init(user: User) {
        allChats = chatModel.getUserChats(user: user)
    }
    
    func sendMessage(to otherUser: User, messageContent: String) {
        
    }
}
