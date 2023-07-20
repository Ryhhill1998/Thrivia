//
//  CodableCryptoOtherUser.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation

struct CodableCryptoOtherUser: Codable {
    // public identity key retrieved from server
    let identityKey: Data
    
    // public signed prekey retrieved from server
    let signedPrekey: Data
    
    // prekey signature retrieved from server
    let prekeySignature: Data
    
    // one-time prekey retrieved from server
    let oneTimePrekey: Data
    
    init(prekeyBundle: [String: String]) {
        identityKey = Data(base64Encoded: prekeyBundle["identityKey"]!)!
        
        signedPrekey = Data(base64Encoded: prekeyBundle["signedPrekey"]!)!
        
        prekeySignature = Data(base64Encoded: prekeyBundle["signedPrekeySignature"]!)!
        
        oneTimePrekey = Data(base64Encoded: prekeyBundle["oneTimePrekey"]!)!
    }
}
