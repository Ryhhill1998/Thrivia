//
//  CryptoUser.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation
import CryptoKit

struct CryptoOtherUser {
    // user ID
    let id: String
    
    // public identity key retrieved from server
    let identityKey: Curve25519.KeyAgreement.PublicKey
    
    // public signed prekey retrieved from server
    let signedPrekey: Curve25519.KeyAgreement.PublicKey
    
    // public signed prekey retrieved from server
    let signedPrekeySigning: Curve25519.Signing.PublicKey
    
    // prekey signature retrieved from server
    let prekeySignature: Data
    
    // one-time prekey
    let oneTimePrekey: Curve25519.KeyAgreement.PublicKey
    
    let prekeyIdentifier: Int
    
    init(codableCryptoOtherUser: CodableCryptoOtherUser) {
        // id
        id = codableCryptoOtherUser.id
        
        // public identity key retrieved from server
        identityKey = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: codableCryptoOtherUser.identityKey)
        
        // public signed prekey retrieved from server
        signedPrekey = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: codableCryptoOtherUser.signedPrekey)
        
        // signed prekey signing
        signedPrekeySigning = try! Curve25519.Signing.PublicKey(rawRepresentation: codableCryptoOtherUser.signedPrekeySigning)
        
        // one-time prekey
        oneTimePrekey = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: codableCryptoOtherUser.oneTimePrekey)
        
        // prekey signature retrieved from server
        prekeySignature = codableCryptoOtherUser.prekeySignature
        
        prekeyIdentifier = codableCryptoOtherUser.prekeyIdentifier
    }
}
