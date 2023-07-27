//
//  MessageField.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import SwiftUI

struct MessageField: View {
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    var body: some View {
        CustomMessageTextField()
            .environmentObject(chatViewModel)
    }
}

struct MessageField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background")
            
            MessageField()
                .environmentObject(ChatViewModel())
        }
    }
}

struct CustomMessageTextField: View {
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    @State var textFieldText: String = ""
    
    func sendPressed(text: String) {
        chatViewModel.sendMessage(content: text)
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10.0) {
            TextField("Type something", text: $textFieldText, axis: .vertical)
                .lineLimit(7)
                .padding(.vertical, 8)
                .frame(minHeight: 35)
                .padding(.horizontal)
                .background(.white)
                .cornerRadius(15)
                .font(.custom("Montserrat", size: 15))
                .foregroundColor(Color("Black"))
                .onSubmit {
                    sendPressed(text: textFieldText)
                }
            
            Button {
                sendPressed(text: textFieldText)
            } label: {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color("Green"))
                    .background(Color("White"))
                    .cornerRadius(17.5)
                    .overlay {
                        Circle()
                            .stroke(.white, lineWidth: 3)
                    }
            }
        }
        .padding()
        .onChange(of: chatViewModel.messageSent) { newValue in
            if newValue == true {
                textFieldText = ""
            }
        }
        .onChange(of: textFieldText) { newValue in
            chatViewModel.resetMessageSent()
        }
    }
}

