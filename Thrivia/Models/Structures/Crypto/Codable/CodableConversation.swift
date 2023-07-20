//
//  Conversation.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation
import CryptoKit

struct CodableConversation: Codable {
    // users
    var user: CodableCryptoUser
    var otherUser: CodableCryptoOtherUser
    
    // boolean to show whether last message was received from other user
    var lastMessageReceived: Bool?
    
    // dh ratchet keys
    var dhRatchetPrivateKey: Data
    var dhRatchetPublicKey: Data
    
    // other user dh key
    var otherUserDhRatchetKey: Data?
    
    // symmetric ratchet chainkeys
    var rootChainKey: Data?
    var sendChainKey: Data?
    var receiveChainKey: Data?
    
    // send chain lengths
    var previousSendChainLength = 0
    var currentSendChainLength = 0
    
    // receive chain length
    var currentReceiveChainLength = 0
    
    // last ephemeral key received
    var lastEphemeralKeyReceived: Data?
    
    init(conversation: Conversation) {
        // users
        user = CodableCryptoUser(cryptoUser: conversation.user)
        otherUser = CodableCryptoOtherUser(cryptoOtherUser: conversation.otherUser)
        
        // boolean to show whether last message was received from other user
        lastMessageReceived = conversation.lastMessageReceived
        
        // dh ratchet keys
        dhRatchetPrivateKey = conversation.dhRatchetPrivateKey.rawRepresentation
        dhRatchetPublicKey = conversation.dhRatchetPublicKey.rawRepresentation
        
        // other user dh key
        otherUserDhRatchetKey = conversation.otherUserDhRatchetKey?.rawRepresentation
        
        // symmetric ratchet chainkeys
        if let rootChainKey = conversation.rootChainKey {
            self.rootChainKey = CodableConversation.convertSymmetricKeyToByteSequence(symmetricKey: rootChainKey)
        }
        
        if let sendChainKey = conversation.sendChainKey {
            self.sendChainKey = CodableConversation.convertSymmetricKeyToByteSequence(symmetricKey: sendChainKey)
        }
        
        if let receiveChainKey = conversation.receiveChainKey {
            self.receiveChainKey = CodableConversation.convertSymmetricKeyToByteSequence(symmetricKey: receiveChainKey)
        }
        
        // send chain lengths
        previousSendChainLength = conversation.previousSendChainLength
        currentSendChainLength = conversation.currentSendChainLength
        
        // receive chain length
        currentReceiveChainLength = conversation.currentReceiveChainLength
        
        // last ephemeral key received
        lastEphemeralKeyReceived = conversation.lastEphemeralKeyReceived
    }
    
    static func convertSymmetricKeyToByteSequence(symmetricKey: SymmetricKey) -> Data {
        var result: Data?
        symmetricKey.withUnsafeBytes { result = Data($0) }
        return result!
    }
}
