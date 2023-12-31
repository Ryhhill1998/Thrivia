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
    
    // public signed prekey retrieved from server
    let signedPrekeySigning: Data
    
    // prekey signature retrieved from server
    let prekeySignature: Data
    
    // one-time prekey retrieved from server
    let oneTimePrekey: Data
    
    let prekeyIdentifier: Int
    
    init(prekeyBundle: [String: String]) {
        id = prekeyBundle["id"]!
        
        identityKey = Data(base64Encoded: prekeyBundle["identityKey"]!)!
        
        signedPrekey = Data(base64Encoded: prekeyBundle["signedPrekey"]!)!
        
        signedPrekeySigning = Data(base64Encoded: prekeyBundle["signedPrekeySigning"]!)!
        
        prekeySignature = Data(base64Encoded: prekeyBundle["signedPrekeySignature"]!)!
        
        oneTimePrekey = Data(base64Encoded: prekeyBundle["oneTimePrekey"]!)!
        
        prekeyIdentifier = Int(prekeyBundle["prekeyIdentifier"]!)!
    }
    
    init(cryptoOtherUser: CryptoOtherUser) {
        id = cryptoOtherUser.getId()
        
        // public identity key retrieved from server
        identityKey = cryptoOtherUser.getIdentityKey().rawRepresentation
        
        // public signed prekey retrieved from server
        signedPrekey = cryptoOtherUser.getSignedPrekey().rawRepresentation
        
        // signed prekey signing
        signedPrekeySigning = cryptoOtherUser.getSignedPrekeySigning().rawRepresentation
        
        // prekey signature retrieved from server
        prekeySignature = cryptoOtherUser.getPrekeySignature()
        
        // one-time prekey retrieved from server
        oneTimePrekey = cryptoOtherUser.getOneTimePrekey().rawRepresentation
        
        prekeyIdentifier = cryptoOtherUser.getPrekeyIdentifier()
    }
}
