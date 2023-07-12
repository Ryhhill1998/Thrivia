//
//  ActionButton.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct ActionButton: View {
    let text: String
    let fontColour: Color
    let backgroundColour: Color
    
    var body: some View {
        Button {
            print("logging in")
        } label: {
            Text(text)
                .font(.custom("Montserrat", size: 22))
                .padding()
                .bold()
        }
        .foregroundColor(fontColour)
        .frame(maxWidth: .infinity)
        .background(backgroundColour)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(text: "Login", fontColour: .white, backgroundColour: Color("Green"))
    }
}
