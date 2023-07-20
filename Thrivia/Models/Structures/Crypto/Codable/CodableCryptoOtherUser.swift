//
//  CodableCryptoOtherUser.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation

struct CodableCryptoOtherUser: Codable {
    // id
    let id: String
    
    // public identity key retrieved from server
    let identityKey: Data
    
    // public signed prekey retrieved from server
    let signedPrekey: Data
    
    // prekey signature retrieved from server
    let prekeySignature: Data
    
    // one-time prekey retrieved from server
    let oneTimePrekey: Data
    
    let prekeyIdentifier: Int
    
    init(prekeyBundle: [String: String]) {
        id = prekeyBundle["id"]!
        
        identityKey = Data(base64Encoded: prekeyBundle["identityKey"]!)!
        
        signedPrekey = Data(base64Encoded: prekeyBundle["signedPrekey"]!)!
        
        prekeySignature = Data(base64Encoded: prekeyBundle["signedPrekeySignature"]!)!
        
        oneTimePrekey = Data(base64Encoded: prekeyBundle["oneTimePrekey"]!)!
        
        prekeyIdentifier = Int(prekeyBundle["prekeyIdentifier"]!)!
    }
    
    init(cryptoOtherUser: CryptoOtherUser) {
        id = cryptoOtherUser.id
        
        // public identity key retrieved from server
        identityKey = cryptoOtherUser.identityKey.rawRepresentation
        
        // public signed prekey retrieved from server
        signedPrekey = cryptoOtherUser.signedPrekey.rawRepresentation
        
        // prekey signature retrieved from server
        prekeySignature = cryptoOtherUser.prekeySignature
        
        // one-time prekey retrieved from server
        oneTimePrekey = cryptoOtherUser.oneTimePrekey.rawRepresentation
        
        prekeyIdentifier = cryptoOtherUser.prekeyIdentifier
    }
}
