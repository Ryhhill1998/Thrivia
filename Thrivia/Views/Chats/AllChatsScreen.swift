//
//  ChatsScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct AllChatsScreen: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 12.0) {
                        ScrollView(.horizontal) {
                            HStack(spacing: 15.0) {
                                AvailableUser(borderColour: .white, backgroundColour: .purple, name: "ZigzagZebra24")
                                
                                AvailableUser(borderColour: .white, backgroundColour: .purple, name: "ZigzagZebra24")
                                
                                AvailableUser(borderColour: .white, backgroundColour: .purple, name: "ZigzagZebra24")
                                
                                AvailableUser(borderColour: .white, backgroundColour: .purple, name: "ZigzagZebra24")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        }
                        
                        Button {
                            print("loading chat")
                        } label: {
                            MessagePreview()
                        }
                        
                        Button {
                            print("loading chat")
                        } label: {
                            MessagePreview()
                        }
                        
                        Button {
                            print("loading chat")
                        } label: {
                            MessagePreview()
                        }
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
        AllChatsScreen()
    }
}

struct AvailableUser: View {
    
    let borderColour: Color
    let backgroundColour: Color
    let name: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 5.0) {
            ActiveUserIcon(size: "large", borderColour: borderColour, backgroundColour: backgroundColour, name: name)
            
            Text(name)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 65.0)
                .font(.custom("Montserrat", size: 12))
                .fontWeight(.medium)
        }
    }
}
