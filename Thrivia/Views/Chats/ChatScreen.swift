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
                            .padding(.top, index == 0 ? 10.0 : 0)
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
                }

            }
    
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: 10.0) {
                    UserIcon(size: "small", borderColour: .white, backgroundColour: Color(uiColor: UIColor(red: 0.57, green: 0.13, blue: 0.50, alpha: 1.00)), name: "ZigzagZebra24")
                    
                    VStack(alignment: .leading, spacing: 1.0) {
                        Text("ZigzagZebra24")
                            .font(.custom("Montserrat", size: 13))
                            .fontWeight(.medium)
                        Text("online")
                            .font(.custom("Montserrat", size: 11))
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "ellipsis")
            }
        }
        .toolbarBackground(Color("Background"), for: .navigationBar)
        .toolbar(.visible, for: .navigationBar)
    }
}

struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatScreen()
    }
}
