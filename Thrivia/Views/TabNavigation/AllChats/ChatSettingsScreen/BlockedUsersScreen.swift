//
//  BlockedUsers.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 24/07/2023.
//

import SwiftUI

struct BlockedUsersScreen: View {
    
    @StateObject private var blockedUsersViewModel = BlockedUsersViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showConfirmUnblockAlert = false
    @State var selectedUser: OtherUser?
    
    let userId: String
    
    func backPressed() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func unblockUser() {
        blockedUsersViewModel.unblockUser(userIdToUnblock: selectedUser!.id)
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            ScrollView {
                ForEach(blockedUsersViewModel.blockedUsers) { user in
                    Button {
                        showConfirmUnblockAlert = true
                        selectedUser = user
                    } label: {
                        HStack(alignment: .center) {
                            HStack(spacing: 15) {
                                UserIcon(size: "small", borderColour: user.getIconColour(), backgroundColour: user.getIconColour(), name: user.getUsername())
                                
                                Text(user.getUsername())
                                    .font(.custom("Montserrat", size: 17))
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Image(systemName: "xmark")
                        }
                        .padding()
                        .background(Color("White"))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
                
                ConfirmationAlert(title: "Unblock \(selectedUser?.getUsername() ?? "none")", message: "Are you sure you want to unblock this user?", confirmButtonText: "Unblock", presentationBind: $showConfirmUnblockAlert, action: unblockUser)
            }
            .padding(.top, 20)
        }
        .onAppear() {
            blockedUsersViewModel.userId = userId
            blockedUsersViewModel.getBlockedUsers()
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    backPressed()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("Black"))
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Blocked Users")
                    .bold()
            }
        }
        .toolbar(.visible, for: .navigationBar)
    }
}
