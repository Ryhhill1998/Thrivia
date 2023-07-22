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
        // need to set isActive to true or false in DB depending if user exists
        auth.addStateDidChangeListener { auth, user in
            let userId = user?.uid
            setAuthState(userId)
        }
    }
    
    func createAuthUser(email: String, username: String, password: String,  errorSetter: @escaping (String) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let authError = error {
                errorSetter(authError.localizedDescription)
            } else {
                let userId = authResult?.user.uid
                
                // create new user doc in database
                if let unwrappedUserId = userId {
                    self.createUserDoc(userId: unwrappedUserId, email: email, username: username, errorSetter: errorSetter)
                }
            }
        }
    }
    
    private func createUserDoc(userId: String, email: String, username: String, errorSetter: @escaping (String) -> Void) {
        let randomIconColour = "IconColour\(Int.random(in: 1...6))"
        
        // create crypto user
        let cryptoUser = CryptoUser(userId: userId)
        
        // create and store codable crypto user
        let codableCryptoUser = CodableCryptoUser(cryptoUser: cryptoUser)
        storeCryptoUserLocally(codableCryptoUser: codableCryptoUser)
        
        // generate key strings for the server
        // identity key
        let publicIdentityKeyString = codableCryptoUser.identityKeyPublic.base64EncodedString()
        
        // signed prekey
        let publicSignedPrekeyString = codableCryptoUser.signedPrekeyPublic.base64EncodedString()
        
        // signed prekey signing
        let publicSignedPrekeySigningString = codableCryptoUser.signedPrekeySigningPublic.base64EncodedString()
        
        // prekey signature
        let signedPrekeySignatureString = cryptoUser.prekeySignature.base64EncodedString()
        
        // 10 x one-time prekeys
        let privateOneTimePrekeys = cryptoUser.oneTimePrekeysPrivate
        let publicOneTimePrekeys = privateOneTimePrekeys.map { $0.publicKey }
        let publicOneTimePrekeyStrings = publicOneTimePrekeys.map { $0.rawRepresentation.base64EncodedString() } // to be stored on server
        
        db.collection("users").document(userId).setData([
            "email": email,
            "username": username,
            "iconColour": randomIconColour,
            "isActive": true,
            "identityKey": publicIdentityKeyString,
            "signedPrekey": publicSignedPrekeyString,
            "signedPrekeySigning": publicSignedPrekeySigningString,
            "signedPrekeySignature": signedPrekeySignatureString,
            "oneTimePrekeys": publicOneTimePrekeyStrings
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func signInAuthUser(email: String, password: String,  errorSetter: @escaping (String) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let authError = error {
                errorSetter(authError.localizedDescription)
            } else {
                let userId = authResult?.user.uid
                print(userId ?? "none")
            }
        }
    }
    
    func logoutUser(userId: String, errorSetter: @escaping (String) -> Void) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            errorSetter(signOutError.localizedDescription)
        }
    }
    
    func deleteUserAccount(userId: String) {
        // connect to db and delete account
    }
    
    func storeCryptoUserLocally(codableCryptoUser: CodableCryptoUser) {
        let defaults = UserDefaults.standard
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(codableCryptoUser)

            // Write/Set Data
            defaults.set(data, forKey: "codableCryptoUser")
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
}
