//
//  ChatScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import SwiftUI

struct ChatScreen: View {
    
    @StateObject private var chatViewModel = ChatViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    let userId: String
    let loadedChat: Chat?
    
    init(userId: String, loadedChat: Chat?) {
        self.userId = userId
        self.loadedChat = loadedChat
    }
    
    func sendPressed(text: String) {
        chatViewModel.sendMessage(content: text)
    }
    
    func backPressed() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            VStack {
                ScrollView {
                    ForEach(Array(chatViewModel.messages.enumerated()), id: \.offset) { index, message in
                        MessageBubble(message: message)
                            .padding(.bottom, 5.0)
                            .padding(.top, index == 0 ? 15.0 : 0)
                    }
                }
                .padding(.top, 5.0)
            }
            .background(Color("White"))
            
            MessageField(sendPressed: sendPressed)
                .background(Color("Background"))
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    backPressed()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("Black"))
                }

            }
    
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: 10.0) {
                    UserIcon(size: "small", borderColour: .white, backgroundColour: chatViewModel.loadedChat?.otherUser.iconColour ?? .purple, name: chatViewModel.loadedChat?.otherUser.username ?? "Username")

                    VStack(alignment: .leading, spacing: 1.0) {
                        Text(chatViewModel.loadedChat?.otherUser.username ?? "Username")
                            .font(.custom("Montserrat", size: 13))
                            .foregroundColor(Color("Black"))
                            .fontWeight(.medium)
                        Text("online")
                            .font(.custom("Montserrat", size: 11))
                            .foregroundColor(Color("Black"))
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "ellipsis")
                    .foregroundColor(Color("Black"))
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(Color("White"), for: .navigationBar)
        .onAppear() {
            chatViewModel.userId = userId
            chatViewModel.loadedChat = loadedChat
            
            chatViewModel.listenToChat()
        }
    }
}
