//
//  NavigationTab.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct NavigationTab: View {
    
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        TabView {
            if authenticationViewModel.authUserId != nil {
                ProgressScreen()
                    .tabItem {
                        Label("Progress", systemImage: "chart.bar.fill")
                    }
                
                ProfileScreen(userId: authenticationViewModel.authUserId!)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                
                AllChatsScreen(userId: authenticationViewModel.authUserId!)
                    .tabItem {
                        Label("Chats", systemImage: "message.fill")
                    }
            } else {
                AuthenticationScreen()
            }
        }
        .environmentObject(authenticationViewModel)
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
