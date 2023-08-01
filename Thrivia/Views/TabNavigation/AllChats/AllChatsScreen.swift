//
//  ChatsScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct AllChatsScreen: View {
    
    @StateObject var chatsViewModel = AllChatsViewModel()
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @State var showConfirmDeleteAlert = false
    @State var isSelectMode = false
    @State var selectedChatIds: Set<String> = []
    @State var navigateToSettings = false
    
    var userId: String
    
    init(userId: String) {
        self.userId = userId
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
                            if authenticationViewModel.activityStatus == true {
                                ScrollView(.horizontal) {
                                    HStack(spacing: 15.0) {
                                        ForEach(chatsViewModel.activeUsers) { otherUser in
                                            Button {
                                                loadChat(otherUser: otherUser)
                                            } label: {
                                                AvailableUser(backgroundColour: otherUser.getIconColour(), name: otherUser.getUsername())
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                    .padding(.top)
                                }
                            }
                            
                            VStack(spacing: 15.0) {
                                ForEach(chatsViewModel.allChats) { chat in
                                    if chat.getLastMessage() != nil {
                                        MessagePreview(id: chat.id, isActive: authenticationViewModel.activityStatus == true && chatsViewModel.getUserActivityStatus(userId: chat.getOtherUser().id), name: chat.getOtherUser().getUsername(), backgroundColour: chat.getOtherUser().getIconColour(), lastMessage: chat.getLastMessage()!.getContent(), read: chat.getLastMessage()!.getRead(), isSelectMode: isSelectMode, isSelected: selectedChatIds.contains(chat.id), selectChat: selectChat(chatId:))
                                            .onTapGesture {
                                                if !isSelectMode {
                                                    loadChat(otherUser: chat.getOtherUser())
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
                            .padding(.top, authenticationViewModel.activityStatus == true ? 0 : 20)
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
            .onAppear() {
                chatsViewModel.setUserId(userId: userId)
                chatsViewModel.listenToActiveUsers()
                chatsViewModel.listenToChats()
            }
            .toolbar(isSelectMode ? .hidden : .visible, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        navigateToSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color("Black"))
                    }

                }
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("Background"), for: .navigationBar)
            .navigationDestination(isPresented: $chatsViewModel.chatIsLoaded) {
                ChatScreen(userId: userId, loadedChat: chatsViewModel.loadedChat ?? nil)
            }
            .navigationDestination(isPresented: $navigateToSettings) {
                ChatSettingsScreen(userId: userId)
                    .environmentObject(authenticationViewModel)
            }
        }
        .accentColor(Color("Black"))
    }
}

struct ChatsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AllChatsScreen(userId: "fL9uh1E9wrZGTgRt0twwmkxOzHg2")
            .environmentObject(AuthenticationViewModel())
    }
}
