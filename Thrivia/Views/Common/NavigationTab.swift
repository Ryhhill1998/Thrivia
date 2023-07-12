//
//  NavigationTab.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct NavigationTab: View {
    var body: some View {
        TabView {
            LoginScreen()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
            
            Text("Search")
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }

            Text("Settings")
                .tabItem {
                    Label("Chats", systemImage: "message.fill")
                }
        }
        .accentColor(Color("Green"))
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
