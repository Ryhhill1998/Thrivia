//
//  ChatScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import SwiftUI

struct ChatScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var chatViewModel = ChatViewModel()
    
    @FocusState private var inputIsFocused: Bool
    
    @State var showConfirmDeleteAlert = false
    @State var isSelectMode = false
    @State var selectedMessageIds: Set<String> = []
    @State var navigateToOptions = false
    @State var messageIdShowTime: String?
    
    let userId: String
    let loadedChat: Chat?
    
    init(userId: String, loadedChat: Chat?) {
        self.userId = userId
        self.loadedChat = loadedChat
    }
    
    func backPressed() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func selectMessage(messageId: String) {
        if selectedMessageIds.contains(messageId) {
            selectedMessageIds.remove(messageId)
        } else {
            selectedMessageIds.insert(messageId)
        }
    }
    
    func cancelSelectMode() {
        isSelectMode = false
        selectedMessageIds = []
    }
    
    func deleteButtonClicked() {
        if !selectedMessageIds.isEmpty {
            showConfirmDeleteAlert = true
        }
    }
    
    func deleteSelectedMessages() {
        chatViewModel.deleteMessages(messageIds: selectedMessageIds)
        
        cancelSelectMode()
    }
    
    var body: some View {
        VStack {
            VStack {
                ScrollViewReader { value in
                    ScrollView {
                        ForEach(Array(chatViewModel.messages.enumerated()), id: \.offset) { index, message in
                            MessageBubble(message: message, showTime: messageIdShowTime == message.id, isSelectMode: isSelectMode, isSelected: selectedMessageIds.contains(message.id), messageSelected: selectMessage(messageId:))
                                .onTapGesture {
                                    if isSelectMode {
                                        selectMessage(messageId: message.id)
                                    } else if messageIdShowTime == message.id {
                                        messageIdShowTime = nil
                                    } else {
                                        messageIdShowTime = message.id
                                        
                                        if index == chatViewModel.lastMessageIndex {
                                            value.scrollTo(chatViewModel.lastMessageIndex)
                                        }
                                    }
                                }
                                .onLongPressGesture {
                                    isSelectMode = true
                                    messageIdShowTime = nil
                                }
                                .padding(.bottom, 5.0)
                                .padding(.top, index == 0 ? 15.0 : 0)
                        }
                    }
                    .background(Color("White"))
                    .padding(.top, 5.0)
                    .onChange(of: chatViewModel.lastMessageIndex) { _ in
                        value.scrollTo(chatViewModel.lastMessageIndex)
                    }
                }
            }
            .onTapGesture {
                inputIsFocused = false
            }
            .alert("Delete", isPresented: $showConfirmDeleteAlert, actions: {
                Button("Delete", role: .destructive) {
                    deleteSelectedMessages()
                }
                
                Button("Cancel", role: .cancel) {}
            }, message: {
                Text("Are you sure you want to delete the selected messages?")
            })
            
            if isSelectMode {
                SelectModeToolbar(selectedItems: selectedMessageIds.count, backgroundColour: Color("Background"), cancel: cancelSelectMode, delete: deleteButtonClicked)
            } else {
                MessageField()
                    .background(Color("Background"))
                    .focused($inputIsFocused)
                    .alert("Send failed", isPresented: $chatViewModel.errorExists, actions: {
                        Button("OK", role: .cancel) {}
                    }, message: {
                        Text(chatViewModel.sendError)
                    })
                    .environmentObject(chatViewModel)
            }
        }
        .onDisappear() {
            chatViewModel.removeListener()
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
                    UserIcon(size: "small", borderColour: .white, backgroundColour: chatViewModel.loadedChat?.getOtherUser().getIconColour() ?? .purple, name: chatViewModel.loadedChat?.getOtherUser().getUsername() ?? "Username")
                    
                    VStack(alignment: .leading, spacing: 1.0) {
                        Text(chatViewModel.loadedChat?.getOtherUser().getUsername() ?? "Username")
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
                Button {
                    navigateToOptions = true
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color("Black"))
                }

            }
        }
        .toolbarBackground(Color("White"), for: .navigationBar)
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .onAppear() {
            chatViewModel.userId = userId
            chatViewModel.loadedChat = loadedChat
            
            chatViewModel.listenToChat()
        }
        .navigationDestination(isPresented: $navigateToOptions) {
            let otherUser = loadedChat?.getOtherUser()
            
            if let otherUserId = otherUser?.id,
               let iconColour = otherUser?.getIconColour(),
               let username = otherUser?.getUsername() {
                ChatOptions(userId: userId, otherUserId: otherUserId, backgroundColour: iconColour, name: username)
            }
        }
    }
}
