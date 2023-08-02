//
//  CryptoUser.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation
import CryptoKit

struct CryptoUser {
    // user ID
    private let id: String
    
    // identity keys
    private let identityKeyPrivate: Curve25519.KeyAgreement.PrivateKey
    private let identityKeyPublic: Curve25519.KeyAgreement.PublicKey
    
    // signed prekeys
    private let signedPrekeyPrivate: Curve25519.KeyAgreement.PrivateKey
    private let signedPrekeyPublic: Curve25519.KeyAgreement.PublicKey
    
    // signed prekey signings
    private let signedPrekeySigningPrivate: Curve25519.Signing.PrivateKey
    private let signedPrekeySigningPublic: Curve25519.Signing.PublicKey
    
    // prekey signature
    private var prekeySignature: Data {
        return try! signedPrekeySigningPrivate.signature(for: identityKeyPublic.rawRepresentation)
    }
    
    // private one-time prekeys
    private var oneTimePrekeysPrivate: [Curve25519.KeyAgreement.PrivateKey]
    
    init(userId: String) {
        id = userId
        
        identityKeyPrivate = Curve25519.KeyAgreement.PrivateKey()
        identityKeyPublic = identityKeyPrivate.publicKey
        
        signedPrekeyPrivate = Curve25519.KeyAgreement.PrivateKey()
        signedPrekeyPublic = signedPrekeyPrivate.publicKey
        
        signedPrekeySigningPrivate = Curve25519.Signing.PrivateKey()
        signedPrekeySigningPublic = signedPrekeySigningPrivate.publicKey
        
        oneTimePrekeysPrivate = (0..<10).map { _ in Curve25519.KeyAgreement.PrivateKey() }
    }
    
    init(codableCryptoUser: CodableCryptoUser) {
        id = codableCryptoUser.id
        
        // identity keys
        identityKeyPrivate = try! Curve25519.KeyAgreement.PrivateKey(rawRepresentation: codableCryptoUser.identityKeyPrivate)
        identityKeyPublic = identityKeyPrivate.publicKey
        
        // signed prekeys
        signedPrekeyPrivate = try! Curve25519.KeyAgreement.PrivateKey(rawRepresentation: codableCryptoUser.signedPrekeyPrivate)
        signedPrekeyPublic = signedPrekeyPrivate.publicKey
        
        // signed prekey signings
        signedPrekeySigningPrivate = try! Curve25519.Signing.PrivateKey(rawRepresentation: codableCryptoUser.signedPrekeySigningPrivate)
        signedPrekeySigningPublic = signedPrekeySigningPrivate.publicKey
        
        // private one-time prekeys
        oneTimePrekeysPrivate = codableCryptoUser.oneTimePrekeysPrivate.map { try! Curve25519.KeyAgreement.PrivateKey(rawRepresentation: $0) }
    }
    
    func getId() -> String {
        return id
    }
    
    func getIdentityKeyPrivate() -> Curve25519.KeyAgreement.PrivateKey {
        return identityKeyPrivate
    }
    
    func getIdentityKeyPublic() -> Curve25519.KeyAgreement.PublicKey {
        return identityKeyPublic
    }
    
    func getSignedPrekeyPrivate() -> Curve25519.KeyAgreement.PrivateKey {
        return signedPrekeyPrivate
    }
    
    func getSignedPrekeyPublic() -> Curve25519.KeyAgreement.PublicKey {
        return signedPrekeyPublic
    }
    
    func getSignedPrekeySigningPrivate() -> Curve25519.Signing.PrivateKey {
        return signedPrekeySigningPrivate
    }
    
    func getSignedPrekeySigningPublic() -> Curve25519.Signing.PublicKey {
        return signedPrekeySigningPublic
    }
    
    func getPrekeySignature() -> Data {
        return prekeySignature
    }
    
    func getOneTimePrekeysPrivate() -> [Curve25519.KeyAgreement.PrivateKey] {
        return oneTimePrekeysPrivate
    }
    
    mutating func replaceOneTimePrekeyAndGetPublicKeyString(prekeyIdentifier: Int) -> String {
        oneTimePrekeysPrivate.remove(at: prekeyIdentifier)
        
        let newOneTimePrekeyPrivate = Curve25519.KeyAgreement.PrivateKey()
        oneTimePrekeysPrivate.append(newOneTimePrekeyPrivate)
        
        let publicKey = newOneTimePrekeyPrivate.publicKey
        return publicKey.rawRepresentation.base64EncodedString()
    }
}
