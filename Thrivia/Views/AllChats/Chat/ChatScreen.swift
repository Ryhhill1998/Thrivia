//
//  ChatScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import SwiftUI

struct ChatScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var messages = [
        Message(id: "1", content: "Hello there! What is your favourite colour?", sent: true, timestamp: Date()),
        Message(id: "2", content: "Hi! My favourite colour is blue", sent: false, timestamp: Date()),
        Message(id: "3", content: "That's my favourite colour too!", sent: true, timestamp: Date())
    ]
    
    let iconColour: Color
    let name: String
    
    func sendPressed(text: String) {
        messages.append(Message(id: "\(messages.count + 1)", content: text, sent: true, timestamp: Date()))
    }
    
    var body: some View {
        VStack {
            VStack {
                ScrollView {
                    ForEach(Array(messages.enumerated()), id: \.offset) { index, message in
                        MessageBubble(message: message)
                            .padding(.bottom, 5.0)
                            .padding(.top, index == 0 ? 15.0 : 0)
                    }
                }
                .background(.white)
                .padding(.top, 5.0)
            }
            
            MessageField(sendPressed: sendPressed)
        }
        .background(Color("Background"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("Black"))
                }

            }
    
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: 10.0) {
                    UserIcon(size: "small", borderColour: .white, backgroundColour: iconColour, name: name)
                    
                    VStack(alignment: .leading, spacing: 1.0) {
                        Text(name)
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
        .toolbarBackground(Color("Background"), for: .navigationBar)
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatScreen(iconColour: Color(uiColor: UIColor(red: 0.57, green: 0.13, blue: 0.50, alpha: 1.00)), name: "ZigzagZebra24")
    }
}