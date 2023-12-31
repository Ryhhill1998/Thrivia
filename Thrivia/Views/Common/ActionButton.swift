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
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ButtonAppearance(text: text, fontColour: fontColour, backgroundColour: backgroundColour)
        }
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(text: "Login", fontColour: .white, backgroundColour: Color("Green")) { print("button clicked") }
    }
}
