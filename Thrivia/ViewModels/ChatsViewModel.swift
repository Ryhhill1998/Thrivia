//
//  AllChatsViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class ChatsViewModel: ObservableObject {
    var userId: String
    var chatsModel = ChatsModel()
    
    @Published var allChats: [Chat]
    
    init(userId: String) {
        self.userId = userId
        allChats = chatsModel.getUserChats(userId: userId)
    }
}
