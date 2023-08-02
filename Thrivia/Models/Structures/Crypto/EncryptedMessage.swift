//
//  EncryptedMessage.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation

class EncryptedMessage: Message {
    private let identityKey: String
    private let ephemeralKey: String
    private let oneTimePreKeyIdentifier: Int
    private let sendChainLength: Int
    private let previousSendChainLength: Int
    
    init(id: String, content: String, timestamp: Date, identityKey: String, ephemeralKey: String, oneTimePreKeyIdentifier: Int, sendChainLength: Int, previousSendChainLength: Int) {
        self.identityKey = identityKey
        self.ephemeralKey = ephemeralKey
        self.oneTimePreKeyIdentifier = oneTimePreKeyIdentifier
        self.sendChainLength = sendChainLength
        self.previousSendChainLength = previousSendChainLength
        super.init(id: id, content: content, sent: false, read: false, timestamp: timestamp)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func getIdentityKey() -> String {
        return identityKey
    }
    
    func getEphemeralKey() -> String {
        return ephemeralKey
    }
    
    func getOneTimePrekeyIdentifier() -> Int {
        return oneTimePreKeyIdentifier
    }
    
    func getSendChainLength() -> Int {
        return sendChainLength
    }
    
    func getPreviousSendChainLength() -> Int {
        return previousSendChainLength
    }
}
