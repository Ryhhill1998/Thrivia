//
//  Conversation.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation
import CryptoKit

struct Conversation {
    // boolean to show whether last message was received from other user
    var lastMessageReceived: Bool?
    
    // dh ratchet keys
    var dhRatchetPrivateKey: Curve25519.KeyAgreement.PrivateKey
    var dhRatchetPublicKey: Curve25519.KeyAgreement.PublicKey
    
    // other user dh key
    var otherUserDhRatchetKey: Curve25519.KeyAgreement.PublicKey?
    
    // symmetric ratchet chainkeys
    var rootChainKey: SymmetricKey?
    var sendChainKey: SymmetricKey?
    var receiveChainKey: SymmetricKey?
    
    // send chain lengths
    var previousSendChainLength = 0
    var currentSendChainLength = 0
    
    // receive chain length
    var currentReceiveChainLength = 0
    
    // last ephemeral key received
    var lastEphemeralKeyReceived: Data?
    
    // previous ephemeral keys received to check if message is new or old chain
    var previouslyReceivedEphemeralKeys: Set<Data> = []
    
    // store message keys for missed messages
    var storedMessageKeys: [StoredKey] = []
    
    init(codableConversation: CodableConversation, previouslyReceivedEphemeralKeys: Set<Data>, storedMessageKeys: [StoredKey]) {
        // last message received
        lastMessageReceived = codableConversation.lastMessageReceived
        
        // dh ratchet key pair
        dhRatchetPrivateKey = try! Curve25519.KeyAgreement.PrivateKey(rawRepresentation: codableConversation.dhRatchetPrivateKey)
        dhRatchetPublicKey = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: codableConversation.dhRatchetPublicKey)
        
        // other user dh ratchet key
        if let otherUserDhRatchetKey = codableConversation.otherUserDhRatchetKey {
            self.otherUserDhRatchetKey = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: otherUserDhRatchetKey)
        }
        
        // chain keys
        if let rootChainKey = codableConversation.rootChainKey {
            self.rootChainKey = SymmetricKey(data: rootChainKey)
        }
        
        if let sendChainKey = codableConversation.sendChainKey {
            self.sendChainKey = SymmetricKey(data: sendChainKey)
        }
        
        if let receiveChainKey = codableConversation.receiveChainKey {
            self.receiveChainKey = SymmetricKey(data: receiveChainKey)
        }
        
        // send chain lengths
        previousSendChainLength = codableConversation.previousSendChainLength
        currentSendChainLength = codableConversation.currentSendChainLength
        
        // receive chain length
        currentReceiveChainLength = codableConversation.currentReceiveChainLength
        
        // last ephemeral key received
        lastEphemeralKeyReceived = codableConversation.lastEphemeralKeyReceived
        
        // previous ephemeral keys received to check if message is new or old chain
        self.previouslyReceivedEphemeralKeys = previouslyReceivedEphemeralKeys
        
        // store message keys for missed messages
        self.storedMessageKeys = storedMessageKeys
    }
}
