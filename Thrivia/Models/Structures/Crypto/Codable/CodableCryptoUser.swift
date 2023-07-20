//
//  CodableCryptoUser.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation

struct CodableCryptoUser: Codable {
    // user ID
    let id: String
    
    // identity keys
    let identityKeyPrivate: Data
    let identityKeyPublic: Data
    
    // signed prekeys
    let signedPrekeyPrivate: Data
    let signedPrekeyPublic: Data
    
    // signed prekey signings
    let signedPrekeySigningPrivate: Data
    let signedPrekeySigningPublic: Data
    
    // private one-time prekeys
    let oneTimePrekeysPrivate: [Data]
    
    init(cryptoUser: CryptoUser) {
        // id
        id = cryptoUser.id
        
        // identity keys
        identityKeyPrivate = cryptoUser.identityKeyPrivate.rawRepresentation
        identityKeyPublic = cryptoUser.identityKeyPublic.rawRepresentation
        
        // signed prekeys
        signedPrekeyPrivate = cryptoUser.signedPrekeyPrivate.rawRepresentation
        signedPrekeyPublic = cryptoUser.signedPrekeyPublic.rawRepresentation
        
        // signed prekey signings
        signedPrekeySigningPrivate = cryptoUser.signedPrekeySigningPrivate.rawRepresentation
        signedPrekeySigningPublic = cryptoUser.signedPrekeySigningPublic.rawRepresentation
        
        // private one-time prekeys
        oneTimePrekeysPrivate = cryptoUser.oneTimePrekeysPrivate.map { $0.rawRepresentation }
    }
}
