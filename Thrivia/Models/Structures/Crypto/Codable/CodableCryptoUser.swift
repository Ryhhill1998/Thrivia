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
        id = cryptoUser.getId()
        
        // identity keys
        identityKeyPrivate = cryptoUser.getIdentityKeyPrivate().rawRepresentation
        identityKeyPublic = cryptoUser.getIdentityKeyPublic().rawRepresentation
        
        // signed prekeys
        signedPrekeyPrivate = cryptoUser.getSignedPrekeyPrivate().rawRepresentation
        signedPrekeyPublic = cryptoUser.getSignedPrekeyPublic().rawRepresentation
        
        // signed prekey signings
        signedPrekeySigningPrivate = cryptoUser.getSignedPrekeySigningPrivate().rawRepresentation
        signedPrekeySigningPublic = cryptoUser.getSignedPrekeySigningPublic().rawRepresentation
        
        // private one-time prekeys
        oneTimePrekeysPrivate = cryptoUser.getOneTimePrekeysPrivate().map { $0.rawRepresentation }
    }
}
