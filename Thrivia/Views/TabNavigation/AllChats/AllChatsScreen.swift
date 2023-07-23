//
//  ChatsScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct AllChatsScreen: View {
    
    @ObservedObject var chatsViewModel: AllChatsViewModel
    
    @State var isEditing = false
    @State var showConfirmDeleteAlert = false
    
    init(userId: String) {
        chatsViewModel = AllChatsViewModel(userId: userId)
    }
    
    func loadChat(otherUser: OtherUser) {
        chatsViewModel.loadChat(otherUser: otherUser)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25.0) {
                        ScrollView(.horizontal) {
                            HStack(spacing: 15.0) {
                                ForEach(chatsViewModel.activeUsers) { otherUser in
                                    Button {
                                        loadChat(otherUser: otherUser)
                                    } label: {
                                        AvailableUser(backgroundColour: otherUser.iconColour, name: otherUser.username)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top)
                        }
                        
                        VStack(spacing: 15.0) {
                            ForEach(chatsViewModel.allChats) { chat in
                                if chat.messages.last != nil {
                                    Button {
                                        loadChat(otherUser: chat.otherUser)
                                    } label: {
                                        MessagePreview(id: chat.id, name: chat.otherUser.username, backgroundColour: chat.otherUser.iconColour, lastMessage: chat.messages.last!.content, editMode: isEditing) { showConfirmDeleteAlert = true }
                                    }
                                    .alert("Delete", isPresented: $showConfirmDeleteAlert, actions: {
                                        Button("Delete", role: .destructive) {
                                            chatsViewModel.deleteChat(id: chat.id)
                                        }
                                        
                                        Button("Cancel", role: .cancel) {}
                                    }, message: {
                                        Text("Are you sure you want to delete this chat?")
                                    })
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }

            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("Background"), for: .navigationBar)
            .navigationDestination(isPresented: $chatsViewModel.chatIsLoaded) {
                ChatScreen(userId: chatsViewModel.userId, loadedChat: chatsViewModel.loadedChat ?? nil)
            }
        }
        .accentColor(Color("Black"))
    }
}

struct ChatsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AllChatsScreen(userId: "VJKOKdNGaVfRK0nQaaoj6lncPHT2")
    }
}

struct AvailableUser: View {
    
    let backgroundColour: Color
    let name: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ActiveUserIcon(size: "large", borderColour: .white, backgroundColour: backgroundColour, name: name)
            
            Text(name)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 65.0)
                .font(.custom("Montserrat", size: 12))
                .fontWeight(.medium)
                .foregroundColor(Color("Black"))
        }
    }
}
