//
//  NavigationTab.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct NavigationTab: View {
    
    @State var navigationTitle = "Progress"
    
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
        .onChange(of: navigationTitle, perform: { newValue in
            print(newValue)
        })
        .accentColor(Color("Green"))
        .navigationBarBackButtonHidden(true)
        .navigationTitle(navigationTitle)
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
