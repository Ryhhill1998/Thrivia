//
//  ChatSettingsScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 27/07/2023.
//

import SwiftUI

struct ChatSettingsScreen: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showTurnOffActivityStatusAlert = false
    
    var userId: String
    
    func backPressed() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func updateActivityStatus(status: Bool) {
        authenticationViewModel.updateUserActivityStatus(activityStatus: status)
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            ScrollView {
                Toggle("Show activity status", isOn: $authenticationViewModel.activityStatus)
                    .font(.custom("Montserrat", size: 17))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Black"))
                    .frame(height: 55)
                    .padding(.horizontal)
                    .background(Color("White"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 1)
                    .onChange(of: authenticationViewModel.activityStatus) { newValue in
                        if newValue == true {
                            updateActivityStatus(status: true)
                        } else {
                            showTurnOffActivityStatusAlert = true
                        }
                    }
                    .alert("Hide activity status?", isPresented: $showTurnOffActivityStatusAlert, actions: {
                        Button("Hide", role: .destructive) {
                            updateActivityStatus(status: false)
                        }
                        
                        Button("Cancel", role: .cancel) {
                            authenticationViewModel.activityStatus = true
                        }
                    }, message: {
                        Text("You won't be able to see when other users are active.")
                    })
                
                NavigationLink {
                    BlockedUsersScreen(userId: userId)
                } label: {
                    HStack {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(Color("Black"))
                        
                        Text("Blocked users")
                            .font(.custom("Montserrat", size: 17))
                            .fontWeight(.medium)
                            .foregroundColor(Color("Black"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 55)
                    .padding(.horizontal)
                    .background(Color("White"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

            }
            .padding(.top, 20)
        }
        .onAppear() {
            authenticationViewModel.getActivityStatus()
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
                Text("Chat Settings")
                    .bold()
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct ChatSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatSettingsScreen(userId: "e7NhVK9n82Shd6UXyLDGzSuKqcD3")
            .environmentObject(AllChatsViewModel(userId: "e7NhVK9n82Shd6UXyLDGzSuKqcD3"))
    }
}
