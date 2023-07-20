//
//  CryptoUser.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation
import CryptoKit

struct CryptoUser {
    // identity keys
    let identityKeyPrivate: Curve25519.KeyAgreement.PrivateKey
    let identityKeyPublic: Curve25519.KeyAgreement.PublicKey
    
    // signed prekeys
    let signedPrekeyPrivate: Curve25519.Signing.PrivateKey
    let signedPrekeyPublic: Curve25519.Signing.PublicKey
    
    // private one-time prekeys
    let oneTimePrekeysPrivate: [Curve25519.KeyAgreement.PrivateKey]
    
    init() {
        identityKeyPrivate = Curve25519.KeyAgreement.PrivateKey()
        identityKeyPublic = identityKeyPrivate.publicKey
        
        signedPrekeyPrivate = Curve25519.Signing.PrivateKey()
        signedPrekeyPublic = signedPrekeyPrivate.publicKey
        
        oneTimePrekeysPrivate = (0..<10).map { _ in Curve25519.KeyAgreement.PrivateKey() }
    }
    
    init(codableCryptoUser: CodableCryptoUser) {
        // identity keys
        identityKeyPrivate = try! Curve25519.KeyAgreement.PrivateKey(rawRepresentation: codableCryptoUser.identityKeyPrivate)
        identityKeyPublic = identityKeyPrivate.publicKey
        
        // signed prekeys
        signedPrekeyPrivate = try! Curve25519.Signing.PrivateKey(rawRepresentation: codableCryptoUser.signedPrekeyPrivate)
        signedPrekeyPublic = signedPrekeyPrivate.publicKey
        
        // private one-time prekeys
        oneTimePrekeysPrivate = codableCryptoUser.oneTimePrekeysPrivate.map { try! Curve25519.KeyAgreement.PrivateKey(rawRepresentation: $0) }
    }
}
