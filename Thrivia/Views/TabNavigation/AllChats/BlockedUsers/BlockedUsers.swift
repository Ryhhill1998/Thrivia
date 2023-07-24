//
//  BlockedUsers.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 24/07/2023.
//

import SwiftUI

struct BlockedUsers: View {
    
    @StateObject private var blockedUsersViewModel = BlockedUsersViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showConfirmUnblockAlert = false
    
    var userId: String
    
    func backPressed() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func unblockUser(userId: String) {
        blockedUsersViewModel.unblockUser(userIdToUnblock: userId)
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            ScrollView {
                ForEach(blockedUsersViewModel.blockedUsers) { user in
                    Button {
                        showConfirmUnblockAlert = true
                    } label: {
                        HStack(alignment: .center) {
                            HStack(spacing: 15) {
                                UserIcon(size: "small", borderColour: user.iconColour, backgroundColour: user.iconColour, name: user.username)
                                
                                Text(user.username)
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
                    .alert("Unblock", isPresented: $showConfirmUnblockAlert, actions: {
                        Button("Unblock", role: .destructive) {
                            unblockUser(userId: user.id)
                        }
                        
                        Button("Cancel", role: .cancel) {}
                    }, message: {
                        Text("Are you sure you want to unblock this user?")
                    })
                }
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

struct BlockedUsers_Previews: PreviewProvider {
    static var previews: some View {
        BlockedUsers(userId: "VxxliXRk4of9K0XqHtgQExc1l9L2")
    }
}
