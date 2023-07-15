//
//  NavigationTab.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct NavigationTab: View {
    
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    @State var counterNotCreated = true
    @State var isAuthenticated = false
    
    func updateAuthStatus(authStatus: Bool) {
        authenticationViewModel.loginAsGuest()
    }
    
    var body: some View {
        TabView {
            if authenticationViewModel.isAuthenticated {
                ProgressScreen(counterNotCreated: counterNotCreated)
                    .tabItem {
                        Label("Progress", systemImage: "chart.bar.fill")
                    }
                
                if authenticationViewModel.authUser != nil {
                    ProfileScreen(updateAuthStatus: updateAuthStatus)
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                    
                    AllChatsScreen()
                        .tabItem {
                            Label("Chats", systemImage: "message.fill")
                        }
                } else {
                    AuthenticationScreen(updateAuthStatus: updateAuthStatus)
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                        .environmentObject(authenticationViewModel)
                    
                    AuthenticationScreen(updateAuthStatus: updateAuthStatus)
                        .tabItem {
                            Label("Chats", systemImage: "message.fill")
                        }
                        .environmentObject(authenticationViewModel)
                }
            } else {
                AuthenticationScreen(updateAuthStatus: updateAuthStatus)
                    .environmentObject(authenticationViewModel)
            }
        }
        .accentColor(Color("Green"))
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct NavigationTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationTab()
            .environmentObject(AuthenticationViewModel())
    }
}
