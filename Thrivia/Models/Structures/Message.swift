//
//  Message.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import Foundation

struct Message: Identifiable, Codable {
    let id: String
    private let content: String
    private let sent: Bool
    private let read: Bool
    private let timestamp: Date
    
    init(id: String, content: String, sent: Bool, read: Bool, timestamp: Date) {
        self.id = id
        self.content = content
        self.sent = sent
        self.read = read
        self.timestamp = timestamp
    }
    
    func getContent() -> String {
        return content
    }
    
    func getSent() -> Bool {
        return sent
    }
    
    func getRead() -> Bool {
        return read
    }
    
    func getTimestamp() -> Date {
        return timestamp
    }
}
