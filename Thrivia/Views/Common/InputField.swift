//
//  InputField.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct InputField: View {
    
    let placeholder: String
    let sendPressed: (String) -> Void
    
    var body: some View {
        CustomTextField(placeholder: placeholder, sendPressed: sendPressed)
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            InputField(placeholder: "Email or Username") { print($0) }
        }
    }
}

struct CustomTextField: View {
    @State var textFieldText: String = ""
    
    let placeholder: String
    let sendPressed: (String) -> Void
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $textFieldText)
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(.white)
                .cornerRadius(10)
                .font(.custom("Montserrat", size: 18))
                .fontWeight(.medium)
                .foregroundColor(Color("DarkGreen"))
                .accentColor(Color("DarkGreen"))
            
            if textFieldText.isEmpty {
                Text(placeholder)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .font(.custom("Montserrat", size: 18))
                    .fontWeight(.medium)
                    .foregroundColor(Color("DarkGreen").opacity(0.5))
            }
        }
        .padding(.horizontal)
    }
}

