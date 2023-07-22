//
//  ProgressButton.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 22/07/2023.
//

import SwiftUI

struct ProgressButton: View {
    
    let text: String
    let foregroundColour: Color
    let backgroundColour: Color
    
    var body: some View {
        HStack(spacing: 10.0) {
            Text(text)
                .font(.custom("Montserrat", size: 20))
                .foregroundColor(foregroundColour)
                .bold()
            
            ProgressView()
                .tint(foregroundColour)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(backgroundColour)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct ProgressButton_Previews: PreviewProvider {
    static var previews: some View {
        ProgressButton(text: "Loading", foregroundColour: .white, backgroundColour: Color("Green"))
    }
}
