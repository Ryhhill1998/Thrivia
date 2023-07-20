//
//  EncryptedMessage.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation

struct EncryptedMessage {
    let id: String
    let cipherText: String
    let identityKey: String
    let ephemeralKey: String
    let oneTimePreKeyIdentifier: Int
    let sendChainLength: Int
    let previousSendChainLength: Int
}
