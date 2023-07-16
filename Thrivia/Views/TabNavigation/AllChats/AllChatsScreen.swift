//
//  ChatsScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct AllChatsScreen: View {
    
    @ObservedObject var chatsViewModel: ChatsViewModel
    
    @State var chatIsLoaded = false
    
    @State var selectedIconColour: Color?
    @State var selectedUserName: String?
    
    init(userId: String) {
        chatsViewModel = ChatsViewModel(userId: userId)
    }
    
    func loadChat(iconColour: Color, name: String) {
        selectedIconColour = iconColour
        selectedUserName = name
        
        chatIsLoaded = true
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25.0) {
                        ScrollView(.horizontal) {
                            HStack(spacing: 15.0) {
                                ForEach(chatsViewModel.activeUsers) { user in
                                    Button {
                                        loadChat(iconColour: user.iconColour, name: user.username)
                                    } label: {
                                        AvailableUser(backgroundColour: user.iconColour, name: user.username)
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
                                        loadChat(iconColour: chat.otherUser.iconColour, name: chat.otherUser.username)
                                    } label: {
                                        MessagePreview(name: chat.otherUser.username, backgroundColour: chat.otherUser.iconColour, lastMessage: chat.messages.last!.content)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("Background"), for: .navigationBar)
            .navigationDestination(isPresented: $chatIsLoaded) {
                ChatScreen(iconColour: selectedIconColour ?? Color(uiColor: UIColor(red: 0.57, green: 0.13, blue: 0.50, alpha: 1.00)), name: selectedUserName ?? "ZigzagZebra24")
            }
        }
    }
}

struct ChatsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AllChatsScreen(userId: "1")
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
