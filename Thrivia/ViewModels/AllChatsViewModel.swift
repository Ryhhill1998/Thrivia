//
//  AllChatsViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

class AllChatsViewModel: ObservableObject {
    var user: User
    @Published var allChats: [Chat]
    
    init() {
        user = User(id: UUID().uuidString, username: "ZigzagZebra24", email: "zigzagzebra24@outlook.com", password: "12345678", iconColour: Color(uiColor: UIColor(red: 0.57, green: 0.13, blue: 0.50, alpha: 1.00)))
        
        allChats = []
    }
    
    func getAllChats(user: User) -> [Chat] {
        return user.chats
    }
}
