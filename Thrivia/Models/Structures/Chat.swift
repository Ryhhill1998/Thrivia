//
//  Chat.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import Foundation

struct Chat: Identifiable {
    let id: String
    let otherUser: OtherUser
    var messages: [Message]
}
