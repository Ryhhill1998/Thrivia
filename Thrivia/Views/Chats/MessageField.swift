//
//  MessageField.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import SwiftUI

struct MessageField: View {
    
    let sendPressed: (String) -> Void
    
    var body: some View {
        CustomMessageTextField(sendPressed: sendPressed)
    }
}

struct MessageField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background")
            
            MessageField { text in
                print(text)
            }
        }
    }
}

struct CustomMessageTextField: View {
    @State var textFieldText: String = ""
    
    let sendPressed: (String) -> Void
    
    var body: some View {
        HStack(spacing: 10.0) {
            ZStack(alignment: .leading) {
                TextField("", text: $textFieldText)
                    .frame(height: 35)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .cornerRadius(15)
                    .font(.headline)
                    .foregroundColor(Color(.black))
                
                if textFieldText.isEmpty {
                    Text("Type something")
                        .frame(height: 35)
                        .padding(.horizontal, 20)
                        .foregroundColor(Color(.black).opacity(0.6))
                }
            }
            
            Button {
                if textFieldText != "" {
                    sendPressed(textFieldText)
                    textFieldText = ""
                }
            } label: {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color("DarkGreen"))
                    .background(.white)
                    .cornerRadius(17.5)
            }
        }
        .padding()
    }
}

