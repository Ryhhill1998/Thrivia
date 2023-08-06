//
//  BlockedUserModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 24/07/2023.
//

import SwiftUI
import FirebaseFirestore

class BlockedUsersModel {
    
    private let db = Firestore.firestore()
    
    func blockUser(signedInUserId: String, userIdToBlock: String, errorSetter: @escaping (String) -> Void, successSetter: @escaping () -> Void) {
        let docRef = db.collection("users").document(signedInUserId)
        
        docRef.getDocument { (document, error) in
            if let userDoc = document, userDoc.exists, let userData = userDoc.data() {
                let blockedUserIds = userData["blockedUserIds"] as? [String]
                
                let setOfBlockedUserIds = Set(blockedUserIds ?? [])
                let userIsBlocked = setOfBlockedUserIds.contains(userIdToBlock)
                
                if userIsBlocked {
                    errorSetter("You have already blocked this user. Go to your blocked users list to unblock.")
                    print("already blocked")
                } else {
                    docRef.updateData([
                        "blockedUserIds": FieldValue.arrayUnion([userIdToBlock])
                    ])
                    
                    successSetter()
                }
            }
        }
    }
    
    func getBlockedUsers(userId: String, blockedUsersSetter: @escaping ([OtherUser]) -> Void) {
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.getDocument { (document, error) in
            if let userDoc = document, userDoc.exists, let userData = userDoc.data() {
                if let blockedUserIds = userData["blockedUserIds"] as? [String] {
                    
                    var blockedUsers: [OtherUser] = []
                    
                    // initialise dispatch group
                    let dispatchGroup = DispatchGroup()
                    
                    for id in blockedUserIds {
                        let blockedUserDocRef = self.db.collection("users").document(id)
                        
                        dispatchGroup.enter()
                        
                        blockedUserDocRef.getDocument { (document, error) in
                            if let blockedUserDoc = document, blockedUserDoc.exists, let blockedUserData = blockedUserDoc.data() {
                                
                                if let username = blockedUserData["username"] as? String,
                                   let iconColour = blockedUserData["iconColour"] as? String {
                                    let otherUser = OtherUser(id: id, username: username, iconColour: Color(iconColour))
                                    blockedUsers.append(otherUser)
                                    dispatchGroup.leave()
                                }
                            }
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        blockedUsersSetter(blockedUsers)
                    }
                }
            }
        }
    }
    
    func unblockUser(signedInUserId: String, userIdToUnblock: String) {
        let userDocRef = db.collection("users").document(signedInUserId)
        
        userDocRef.updateData([
            "blockedUserIds": FieldValue.arrayRemove([userIdToUnblock])
        ])
    }
}
