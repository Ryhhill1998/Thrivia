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
                    VStack(spacing: 12.0) {
                        ScrollView(.horizontal) {
                            HStack(spacing: 15.0) {
                                AvailableUser()
                                AvailableUser()
                                AvailableUser()
                                AvailableUser()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        }
                        
                        MessagePreview()
                        MessagePreview()
                        MessagePreview()
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

struct AvailableUser: View {
    var body: some View {
        VStack(alignment: .center, spacing: 5.0) {
            ActiveUserIcon(size: "large")
            
            Text("ZigzagZebra24")
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 65.0)
                .font(.custom("Montserrat", size: 12))
                .fontWeight(.medium)
        }
    }
}
