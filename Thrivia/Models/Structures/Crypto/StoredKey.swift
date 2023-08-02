//
//  StoredKey.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation

struct StoredKey: Codable {
    private let messageNumber: Int
    private let key: Data
    private let rawEphemeralKey: Data
    
    init(messageNumber: Int, key: Data, rawEphemeralKey: Data) {
        self.messageNumber = messageNumber
        self.key = key
        self.rawEphemeralKey = rawEphemeralKey
    }
    
    func getMessageNumber() -> Int {
        return messageNumber
    }
    
    func getKey() -> Data {
        return key
    }
    
    func getRawEphemeralKey() -> Data {
        return rawEphemeralKey
    }
}
