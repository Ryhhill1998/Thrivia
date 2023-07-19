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
        let publicIdentityKey = privateIdentityKey.publicKey
        
        // signed prekeys
        let privateSignedPrekey = generatePrivateSignedPrekey()
        let publicSignedPrekey = privateSignedPrekey.publicKey
        
        // prekey signature
        let signedPrekeySignature = generateSignedPrekeySignature(privateSignedPrekey: privateSignedPrekey, publicIdentityKey: publicIdentityKey)
        
        // 10 x one-time prekeys
        let oneTimePrekeys = generatePrivateOneTimePrekeysArray(numberOfKeys: 10)
        
        db.collection("users").document(userId).setData([
            "email": email,
            "username": username,
            "iconColour": randomIconColour,
            "isActive": true
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
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
