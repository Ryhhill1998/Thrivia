//
//  Message.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import Foundation

struct Message: Identifiable, Codable {
    let id: String
    let content: String
    let sent: Bool
    let timestamp: Date
}
