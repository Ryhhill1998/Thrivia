//
//  ButtonAppearance.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 13/07/2023.
//

import SwiftUI

struct ButtonAppearance: View {
    
    let text: String
    let fontColour: Color
    let backgroundColour: Color
    
    var body: some View {
        Text(text)
            .font(.custom("Montserrat", size: 22))
            .padding()
            .bold()
            .foregroundColor(fontColour)
            .frame(maxWidth: .infinity)
            .background(backgroundColour)
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

struct ButtonAppearance_Previews: PreviewProvider {
    static var previews: some View {
        ButtonAppearance(text: "Login", fontColour: .white, backgroundColour: Color("Green"))
    }
}
