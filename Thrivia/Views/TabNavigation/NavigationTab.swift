//
//  NavigationTab.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct NavigationTab: View {
    
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    
    @State var counterNotCreated = true
    
    @State var navigationTitle = "Alcohol"
    @State var isAuthenticated = false
    
    func updateAuthStatus(authStatus: Bool) {
        print("updating auth status")
    }
    
    var body: some View {
        TabView(selection: $navigationTitle) {
            if authenticationViewModel.isAuthenticated {
                ProgressScreen(counterNotCreated: counterNotCreated)
                    .tabItem {
                        Label("Progress", systemImage: "chart.bar.fill")
                    }
                    .tag("Alcohol")
            } else {
                AuthenticationScreen(updateAuthStatus: updateAuthStatus)
            }
            
            if authenticationViewModel.isAuthenticated {
                ProfileScreen(updateAuthStatus: updateAuthStatus)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag("Profile")
            } else {
                AuthenticationScreen(updateAuthStatus: updateAuthStatus)
            }
            
            if authenticationViewModel.isAuthenticated {
                AllChatsScreen()
                    .tabItem {
                        Label("Chats", systemImage: "message.fill")
                    }
                    .tag("Chats")
            } else {
                AuthenticationScreen(updateAuthStatus: updateAuthStatus)
            }
        }
        .accentColor(Color("Green"))
        .navigationBarBackButtonHidden(true)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct NavigationTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationTab()
            .environmentObject(AuthenticationViewModel())
    }
}
