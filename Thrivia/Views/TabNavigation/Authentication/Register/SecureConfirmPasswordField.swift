//
//  SecureConfirmPassword.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 03/08/2023.
//

import SwiftUI

struct SecureConfirmPasswordField: View {
    
    @Binding var confirmPasswordFieldText: String
    let borderColour: Color
    
    var body: some View {
        SecureField("Confirm password", text: $confirmPasswordFieldText)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .font(.custom("Montserrat", size: 18))
            .fontWeight(.medium)
            .foregroundColor(Color("Black"))
            .background(Color("White"))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColour, lineWidth: 3)
            )
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
