//
//  NavigationTab.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct NavigationTab: View {
    
    @State var navigationTitle = "Progress"
    
    init(navigationTitle: String = "Progress") {
        self.navigationTitle = navigationTitle
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.init(Color("DarkGreen"))]
    }
    
    var body: some View {
        TabView(selection: $navigationTitle) {
            ProgressScreen()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
                .tag("Progress")
            
            ProfileScreen()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag("Profile")

            ChatsScreen()
                .tabItem {
                    Label("Chats", systemImage: "message.fill")
                }
                .tag("Chats")
        }
        .accentColor(Color("Green"))
        .navigationBarBackButtonHidden(true)
        .navigationTitle(navigationTitle)
        .navigationBarHidden(navigationTitle == "Progress")
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
