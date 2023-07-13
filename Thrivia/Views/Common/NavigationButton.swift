//
//  NavigationButton.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct NavigationButton: View {
    
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

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButton(text: "Login", fontColour: .white, backgroundColour: Color("Green"))
    }
}
