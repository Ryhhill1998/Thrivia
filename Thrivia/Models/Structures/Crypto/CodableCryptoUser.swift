//
//  CodableCryptoUser.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation

struct CodableCryptoUser {
    // identity keys
    let identityKeyPrivate: Data
    let identityKeyPublic: Data
    
    // signed prekeys
    let signedPrekeyPrivate: Data
    let signedPrekeyPublic: Data
    
    // private one-time prekeys
    let oneTimePrekeysPrivate: [Data]
}
