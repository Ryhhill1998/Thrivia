//
//  NavigationTab.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct NavigationTab: View {
    
    @State var navigationTitle = "Alcohol"
    @State var isAuthenticated = false
    
    func updateAuthStatus(authStatus: Bool) {
        print("updating auth status")
        isAuthenticated = authStatus
    }
    
    init(navigationTitle: String = "Alcohol") {
        self.navigationTitle = navigationTitle
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.init(Color("DarkGreen"))]
    }
    
    var body: some View {
        TabView(selection: $navigationTitle) {
            if isAuthenticated {
                ProgressScreen()
                    .tabItem {
                        Label("Progress", systemImage: "chart.bar.fill")
                    }
                    .tag("Alcohol")
            } else {
                AuthenticationScreen(updateAuthStatus: updateAuthStatus)
            }
            
            ProfileScreen()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag("Profile")
            
            AllChatsScreen()
                .tabItem {
                    Label("Chats", systemImage: "message.fill")
                }
                .tag("Chats")
        }
        .accentColor(Color("Green"))
        .navigationBarBackButtonHidden(true)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct NavigationTab_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background")
            
            NavigationTab()
        }
    }
}
