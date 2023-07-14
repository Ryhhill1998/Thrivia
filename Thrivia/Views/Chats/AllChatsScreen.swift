//
//  ChatsScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct AllChatsScreen: View {
    
    @State private var chatIsLoaded = false
    
    func loadChat() {
        chatIsLoaded = true
    }
    
    func loadAllChats() {
        print("loading all chats")
    }
    
    init(chatIsLoaded: Bool = false) {
        self.chatIsLoaded = chatIsLoaded
        
        // will instead be done with initialising an observable object - ViewModel
        loadAllChats()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 12.0) {
                        ScrollView(.horizontal) {
                            HStack(spacing: 15.0) {
                                Button {
                                    loadChat()
                                } label: {
                                    AvailableUser(backgroundColour: Color(uiColor: UIColor(red: 0.57, green: 0.13, blue: 0.50, alpha: 1.00)), name: "ZigzagZebra24")
                                }
                                
                                Button {
                                    loadChat()
                                } label: {
                                    AvailableUser(backgroundColour: Color(uiColor: UIColor(red: 0.14, green: 0.50, blue: 0.70, alpha: 1.00)), name: "CoolCucumber8080")
                                }
                                
                                Button {
                                    loadChat()
                                } label: {
                                    AvailableUser(backgroundColour: Color(uiColor: UIColor(red: 0.13, green: 0.57, blue: 0.31, alpha: 1.00)), name: "BoxingGiraffe99")
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        }
                        
                        Button {
                            loadChat()
                        } label: {
                            MessagePreview(name: "ZigzagZebra24", backgroundColour: Color(uiColor: UIColor(red: 0.57, green: 0.13, blue: 0.50, alpha: 1.00)), lastMessage: "That’s what thrivia is here for! What would you like to talk about?")
                        }
                        
                        Button {
                            loadChat()
                        } label: {
                            MessagePreview(name: "CoolCucumber8080", backgroundColour: Color(uiColor: UIColor(red: 0.14, green: 0.50, blue: 0.70, alpha: 1.00)), lastMessage: "I’ve never heard of that before but it sounds cool!")
                        }
                        
                        Button {
                            loadChat()
                        } label: {
                            MessagePreview(name: "BoxingGiraffe99", backgroundColour: Color(uiColor: UIColor(red: 0.13, green: 0.57, blue: 0.31, alpha: 1.00)), lastMessage: "Hi there! Are you okay?")
                        }
                    }
                }
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("Background"), for: .navigationBar)
            .navigationDestination(isPresented: $chatIsLoaded) {
                ChatScreen()
            }
        }
    }
}

struct ChatsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AllChatsScreen()
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
        }
    }
}
