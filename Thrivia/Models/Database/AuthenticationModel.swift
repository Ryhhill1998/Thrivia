//
//  UserModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import CryptoKit

class AuthenticationModel {
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func listenForAuthStateChanges(setAuthState: @escaping (String?) -> Void) {
        auth.addStateDidChangeListener { auth, user in
            let userId = user?.uid
            setAuthState(userId)
        }
    }
    
    func createAuthUser(email: String, username: String, password: String) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let authError = error {
                print(authError.localizedDescription)
            } else {
                let userId = authResult?.user.uid
                print(userId ?? "none")
                
                // create new user doc in database
                if let unwrappedUserId = userId {
                    self.createUserDoc(userId: unwrappedUserId, email: email, username: username)
                }
            }
        }
    }
    
    private func createUserDoc(userId: String, email: String, username: String) {
        let randomIconColour = "IconColour\(Int.random(in: 1...6))"
        
        // generate keys for the server
        // identity keys
        let privateIdentityKey = generatePrivateKey()
        storeKeyLocally(key: privateIdentityKey.rawRepresentation.base64EncodedString(), keyName: "privateIdentityKey")
        let publicIdentityKey = privateIdentityKey.publicKey
        let publicIdentityKeyString = convertPublicKeyToBase64String(publicKey: publicIdentityKey) // to be stored on server
        
        // signed prekeys
        let privateSignedPrekey = generatePrivateSignedPrekey()
        storeKeyLocally(key: privateSignedPrekey.rawRepresentation.base64EncodedString(), keyName: "privateSignedPrekey")
        let publicSignedPrekey = privateSignedPrekey.publicKey
        let publicSignedPrekeyString = publicSignedPrekey.rawRepresentation.base64EncodedString() // to be stored on server
        
        // prekey signature - to be stored on server as String
        let signedPrekeySignature = generateSignedPrekeySignature(privateSignedPrekey: privateSignedPrekey, publicIdentityKey: publicIdentityKey)
        let signedPrekeySignatureString = signedPrekeySignature?.base64EncodedString() // to be stored on server
        
        // 10 x one-time prekeys
        let privateOneTimePrekeys = generatePrivateOneTimePrekeysArray(numberOfKeys: 10)
        
        for i in 0..<privateOneTimePrekeys.count {
            storeKeyLocally(key: privateOneTimePrekeys[i].rawRepresentation.base64EncodedString(), keyName: "privateOneTimePrekey\(i)")
        }
        
        let publicOneTimePrekeys = privateOneTimePrekeys.map { $0.publicKey }
        let publicOneTimePrekeyStrings = publicOneTimePrekeys.map { convertPublicKeyToBase64String(publicKey: $0) } // to be stored on server
        
        db.collection("users").document(userId).setData([
            "email": email,
            "username": username,
            "iconColour": randomIconColour,
            "isActive": true,
            "identityKey": publicIdentityKeyString,
            "signedPrekey": publicSignedPrekeyString,
            "signedPrekeySignature": signedPrekeySignatureString ?? "none",
            "oneTimePrekeys": publicOneTimePrekeyStrings
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    private func storeKeyLocally(key: String, keyName: String) {
        let defaults = UserDefaults.standard
        defaults.set(key, forKey: keyName)
    }
    
    private func convertPublicKeyToBase64String(publicKey: Curve25519.KeyAgreement.PublicKey) -> String {
        return publicKey.rawRepresentation.base64EncodedString()
    }
    
    private func generatePrivateKey() -> Curve25519.KeyAgreement.PrivateKey {
        return Curve25519.KeyAgreement.PrivateKey()
    }
    
    private func generatePrivateSignedPrekey() -> Curve25519.Signing.PrivateKey {
        return Curve25519.Signing.PrivateKey()
    }
    
    private func generateSignedPrekeySignature(privateSignedPrekey: Curve25519.Signing.PrivateKey, publicIdentityKey: Curve25519.KeyAgreement.PublicKey) -> Data? {
        do {
            return try privateSignedPrekey.signature(for: publicIdentityKey.rawRepresentation)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func generatePrivateOneTimePrekeysArray(numberOfKeys: Int) -> [Curve25519.KeyAgreement.PrivateKey] {
        var privateOneTimePrekeys: [Curve25519.KeyAgreement.PrivateKey] = []
        
        for _ in 0..<numberOfKeys {
            let oneTimePrekey = generatePrivateKey()
            privateOneTimePrekeys.append(oneTimePrekey)
        }
        
        return privateOneTimePrekeys
    }
    
    func signInAuthUser(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let authError = error {
                print(authError.localizedDescription)
            } else {
                let userId = authResult?.user.uid
                print(userId ?? "none")
            }
        }
    }
    
    func logoutUser(userId: String) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func deleteUserAccount(userId: String) {
        // connect to db and delete account
    }
}
