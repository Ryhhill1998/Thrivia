//
//  ChatsScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct AllChatsScreen: View {
    
    @ObservedObject var chatsViewModel: AllChatsViewModel
    
    @State var showConfirmDeleteAlert = false
    @State var isSelectMode = false
    @State var selectedChatIds: Set<String> = []
    @State var navigateToBlockedList = false
    
    var userId: String
    
    init(userId: String) {
        self.userId = userId
        
        chatsViewModel = AllChatsViewModel(userId: userId)
    }
    
    func loadChat(otherUser: OtherUser) {
        chatsViewModel.loadChat(otherUser: otherUser)
    }
    
    func selectChat(chatId: String) {
        if selectedChatIds.contains(chatId) {
            selectedChatIds.remove(chatId)
        } else {
            selectedChatIds.insert(chatId)
        }
    }
    
    func cancelSelectMode() {
        isSelectMode = false
        selectedChatIds = []
    }
    
    func deleteClicked() {
        if !selectedChatIds.isEmpty {
            showConfirmDeleteAlert = true
        }
    }
    
    func deleteSelectedChats() {
        chatsViewModel.deleteChats(chatIds: selectedChatIds)
        
        cancelSelectMode()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                VStack {
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
                                        MessagePreview(id: chat.id, isActive: chatsViewModel.getUserActivityStatus(userId: chat.otherUser.id), name: chat.otherUser.username, backgroundColour: chat.otherUser.iconColour, lastMessage: chat.messages.last!.content, read: chat.messages.last!.read, isSelectMode: isSelectMode, isSelected: selectedChatIds.contains(chat.id), selectChat: selectChat(chatId:))
                                            .onTapGesture {
                                                if !isSelectMode {
                                                    loadChat(otherUser: chat.otherUser)
                                                } else {
                                                    selectChat(chatId: chat.id)
                                                }
                                            }
                                            .onLongPressGesture {
                                                isSelectMode = true
                                            }
                                    }
                                }
                            }
                            .alert("Delete", isPresented: $showConfirmDeleteAlert, actions: {
                                Button("Delete", role: .destructive) {
                                    deleteSelectedChats()
                                }
                                
                                Button("Cancel", role: .cancel) {}
                            }, message: {
                                Text("Are you sure you want to delete the selected chats?")
                            })
                        }
                    }
                    
                    if isSelectMode {
                        SelectModeToolbar(selectedItems: selectedChatIds.count, backgroundColour: Color("White"), cancel: cancelSelectMode, delete: deleteClicked)
                    }
                }
            }
            .toolbar(isSelectMode ? .hidden : .visible, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        navigateToBlockedList = true
                    } label: {
                        Image(systemName: "minus.circle")
                            .foregroundColor(Color("Black"))
                    }

                }
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("Background"), for: .navigationBar)
            .navigationDestination(isPresented: $chatsViewModel.chatIsLoaded) {
                ChatScreen(userId: chatsViewModel.userId, loadedChat: chatsViewModel.loadedChat ?? nil)
            }
            .navigationDestination(isPresented: $navigateToBlockedList) {
                BlockedUsersScreen(userId: userId)
            }
        }
        .accentColor(Color("Black"))
    }
}

struct ChatsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AllChatsScreen(userId: "fL9uh1E9wrZGTgRt0twwmkxOzHg2")
    }
}
