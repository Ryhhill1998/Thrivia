//
//  CodableCryptoUser.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation

struct CodableCryptoUser: Codable {
    // identity keys
    let identityKeyPrivate: Data
    let identityKeyPublic: Data
    
    // signed prekeys
    let signedPrekeyPrivate: Data
    let signedPrekeyPublic: Data
    
    // private one-time prekeys
    let oneTimePrekeysPrivate: [Data]
    
    init(cryptoUser: CryptoUser) {
        // identity keys
        identityKeyPrivate = cryptoUser.identityKeyPrivate.rawRepresentation
        identityKeyPublic = cryptoUser.identityKeyPublic.rawRepresentation
        
        // signed prekeys
        signedPrekeyPrivate = cryptoUser.signedPrekeyPrivate.rawRepresentation
        signedPrekeyPublic = cryptoUser.signedPrekeyPublic.rawRepresentation
        
        // private one-time prekeys
        oneTimePrekeysPrivate = cryptoUser.oneTimePrekeysPrivate.map { $0.rawRepresentation }
    }
}
