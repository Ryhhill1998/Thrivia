//
//  OtherUser.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 16/07/2023.
//

import SwiftUI

struct OtherUser: Identifiable {
    let id: String
    private var username: String
    private var iconColour: Color
    
    init(id: String, username: String, iconColour: Color) {
        self.id = id
        self.username = username
        self.iconColour = iconColour
    }
    
    func getUsername() -> String {
        return username
    }
    
    func getIconColour() -> Color {
        return iconColour
    }
}
