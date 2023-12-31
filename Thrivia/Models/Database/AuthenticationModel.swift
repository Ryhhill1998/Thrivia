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
            
            if let userId = userId {
                self.loadSavedActivityStatus(userId: userId)
            }
        }
    }
    
    func registerUser(email: String, username: String, password: String,  errorSetter: @escaping (String) -> Void) {
        UserDefaults.standard.removeObject(forKey: "counter")
        
        // check if username already in use
        db.collection("users").whereField("username", isEqualTo: username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let foundDocuments = querySnapshot!.documents
                    
                    if foundDocuments.isEmpty {
                        // create new user if username not already in use
                        self.createAuthUser(email: email, username: username, password: password, errorSetter: errorSetter)
                    } else {
                        errorSetter("The username is already in use by another account.")
                    }
                }
            }
    }
    
    private func createAuthUser(email: String, username: String, password: String,  errorSetter: @escaping (String) -> Void) {
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
        Utilities.storeCryptoUserInUserDefaults(codableCryptoUser: codableCryptoUser)
        
        // generate key strings for the server
        // identity key
        let publicIdentityKeyString = codableCryptoUser.identityKeyPublic.base64EncodedString()
        
        // signed prekey
        let publicSignedPrekeyString = codableCryptoUser.signedPrekeyPublic.base64EncodedString()
        
        // signed prekey signing
        let publicSignedPrekeySigningString = codableCryptoUser.signedPrekeySigningPublic.base64EncodedString()
        
        // prekey signature
        let signedPrekeySignatureString = cryptoUser.getPrekeySignature().base64EncodedString()
        
        // 10 x one-time prekeys
        let privateOneTimePrekeys = cryptoUser.getOneTimePrekeysPrivate()
        let publicOneTimePrekeys = privateOneTimePrekeys.map { $0.publicKey }
        let publicOneTimePrekeyStrings = publicOneTimePrekeys.map { $0.rawRepresentation.base64EncodedString() }
        
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
    
    func updateUserActivityStatusInDB(userId: String, activityStatus: Bool) {
        let docRef = db.collection("users").document(userId)
        
        docRef.updateData([
            "isActive": activityStatus
        ])
    }
    
    func saveUserActivityStatus(userId: String, activityStatus: Bool) {
        let defaults = UserDefaults.standard
        
        defaults.set(activityStatus, forKey: "activityStatus")
        
        updateUserActivityStatusInDB(userId: userId, activityStatus: activityStatus)
    }
    
    func getUserActivityStatus(userId: String, activityStatusSetter: @escaping (Bool) -> Void) {
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let data = document?.data() {
                if let activityStatus = data["isActive"] as? Bool {
                    activityStatusSetter(activityStatus)
                }
            }
        }
    }
    
    func loadSavedActivityStatus(userId: String) {
        let savedActivtiyStatus = Utilities.retrieveSavedActivityStatusFromUserDefaults() ?? true
        
        updateUserActivityStatusInDB(userId: userId, activityStatus: savedActivtiyStatus)
    }
    
    func LoginAuthUser(email: String, password: String,  errorSetter: @escaping (String) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let authError = error {
                errorSetter(authError.localizedDescription)
            } else {
                print("Successfully logged in")
            }
        }
    }
    
    func logoutUser(userId: String, errorSetter: @escaping (String) -> Void) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            updateUserActivityStatusInDB(userId: userId, activityStatus: false)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            errorSetter(signOutError.localizedDescription)
        }
    }
    
    func deleteUserAccount(userId: String, errorSetter: @escaping (String) -> Void) {
        // connect to db and delete account
        let user = Auth.auth().currentUser

        user?.delete { error in
            if let error = error {
                errorSetter(error.localizedDescription)
            } else {
                self.deleteUserAndAllDataFromDB(userId: userId)
            }
        }
    }
    
    private func deleteUserAndAllDataFromDB(userId: String) {
        let docRef = db.collection("users").document(userId)
        
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                return
            }
            
            guard let data = document.data() else {
                return
            }
            
            if let chatIds = data["chatIds"] as? [String] {
                for chatId in chatIds {
                    // delete chat ID from all user docs involved in the chat
                    self.deleteChatIdFromAllUserDocs(chatId: chatId)
                    
                    // delete the chat doc with this chat ID
                    self.deleteChatDoc(chatId: chatId)
                }
                
                // delete user doc
                self.deleteUserDoc(userId: userId)
            }
        }
    }
    
    private func deleteUserDoc(userId: String) {
        db.collection("users").document(userId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    private func deleteChatDoc(chatId: String) {
        db.collection("chats").document(chatId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    private func deleteChatIdFromAllUserDocs(chatId: String) {
        db.collection("users").whereField("chatIds", arrayContains: chatId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let foundDocuments = querySnapshot?.documents {
                        for document in foundDocuments {
                            let userId = document.documentID
                            self.deleteChatIdFromUserDoc(userId: userId, chatId: chatId)
                        }
                    }
                }
            }
    }
    
    private func deleteChatIdFromUserDoc(userId: String, chatId: String) {
        let docRef = db.collection("users").document(userId)
        
        docRef.updateData([
            "chatIds": FieldValue.arrayRemove([chatId])
        ])
    }
}
