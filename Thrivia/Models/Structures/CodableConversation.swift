//
//  Conversation.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation

struct CodableConversation: Codable {
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
}
