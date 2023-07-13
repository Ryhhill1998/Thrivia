//
//  ChatsScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct ChatsScreen: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        HStack(spacing: 10.0) {
                            UserIcon()
                            
                            UserIcon()
                            
                            UserIcon()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                }
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("Background"), for: .navigationBar)
        }
    }
}

struct ChatsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatsScreen()
    }
}
