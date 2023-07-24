//
//  BlockedUsersViewModel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 24/07/2023.
//

import SwiftUI

class BlockedUsersViewModel: ObservableObject {
    
    var blockedUsersModel = BlockedUsersModel()
    
    var userId: String?
    
    @Published var blockedUsers: [OtherUser] = []
    
    func setBlockedUsers(blockedUsers: [OtherUser]) {
        self.blockedUsers = blockedUsers
    }
    
    func getBlockedUsers() {
        if let userId = userId {
            blockedUsersModel.getBlockedUsers(userId: userId, blockedUsersSetter: setBlockedUsers(blockedUsers:))
        }
    }
    
    func unblockUser(userIdToUnblock: String) {
        if let userId = userId {
            blockedUsersModel.unblockUser(signedInUserId: userId, userIdToUnblock: userIdToUnblock)
            
            blockedUsers = blockedUsers.filter {
                $0.id != userIdToUnblock
            }
        }
    }
}
