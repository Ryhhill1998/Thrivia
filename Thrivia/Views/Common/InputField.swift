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
        CustomInputTextField(placeholder: placeholder, sendPressed: sendPressed)
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

struct CustomInputTextField: View {
    @State var textFieldText: String = ""
    
    let placeholder: String
    let sendPressed: (String) -> Void
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextField(placeholder, text: $textFieldText)
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(.white)
                .cornerRadius(10)
                .font(.custom("Montserrat", size: 18))
                .fontWeight(.medium)
                .foregroundColor(Color("Black"))
        }
        .padding(.horizontal)
    }
}

