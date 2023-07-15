//
//  NavigationTab.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct NavigationTab: View {
    
    @State var counterNotCreated = true
    
    @State var navigationTitle = "Alcohol"
    @State var isAuthenticated = false
    
    func updateAuthStatus(authStatus: Bool) {
        print("updating auth status")
        isAuthenticated = authStatus
    }
    
    var body: some View {
        TabView(selection: $navigationTitle) {
            if isAuthenticated {
                ProgressScreen(counterNotCreated: counterNotCreated)
                    .tabItem {
                        Label("Progress", systemImage: "chart.bar.fill")
                    }
                    .tag("Alcohol")
            } else {
                AuthenticationScreen(updateAuthStatus: updateAuthStatus)
            }
            
            if isAuthenticated {
                ProfileScreen(updateAuthStatus: updateAuthStatus)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag("Profile")
            } else {
                AuthenticationScreen(updateAuthStatus: updateAuthStatus)
            }
            
            if isAuthenticated {
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
    }
}
