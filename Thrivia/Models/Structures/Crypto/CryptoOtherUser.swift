//
//  CryptoUser.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation
import CryptoKit

struct CryptoOtherUser {
    // public identity key retrieved from server
    let identityKey: Curve25519.KeyAgreement.PublicKey
    
    // public signed prekey retrieved from server
    let signedPrekey: Curve25519.Signing.PublicKey
    
    // prekey signature retrieved from server
    let prekeySignature: Data
    
    init(codableCryptoOtherUser: CodableCryptoOtherUser) {
        // public identity key retrieved from server
        identityKey = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: codableCryptoOtherUser.identityKey)
        
        // public signed prekey retrieved from server
        signedPrekey = try! Curve25519.Signing.PublicKey(rawRepresentation: codableCryptoOtherUser.signedPrekey)
        
        // prekey signature retrieved from server
        prekeySignature = codableCryptoOtherUser.prekeySignature
    }
}
