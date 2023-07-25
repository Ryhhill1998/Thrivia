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
        HStack(alignment: .bottom, spacing: 10.0) {
            ZStack(alignment: .leading) {
                TextField("Type something", text: $textFieldText, axis: .vertical)
                    .lineLimit(7)
                    .padding(.vertical, 10)
                    .frame(minHeight: 40)
                    .padding(.horizontal)
                    .background(.white)
                    .cornerRadius(15)
                    .font(.custom("Montserrat", size: 15))
                    .foregroundColor(Color("Black"))
            }
            
            Button {
                if textFieldText != "" {
                    sendPressed(textFieldText)
                    textFieldText = ""
                }
            } label: {
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
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
    }
}

