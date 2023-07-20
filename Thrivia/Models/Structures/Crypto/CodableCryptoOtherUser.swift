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
}
