//
//  FieldInput.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 04/08/2023.
//

import SwiftUI

struct FieldInput: View {
    
    let fieldType: String
    let placeholder: String
    @Binding var fieldValue: String
    
    var body: some View {
        HStack {
            FieldLabel(label: "Current \(fieldType)")
            
            TextField(placeholder, text: $fieldValue)
                .multilineTextAlignment(.trailing)
                .font(.custom("Montserrat", size: 15))
                .fontWeight(.medium)
                .foregroundColor(Color("Black"))
        }
    }
}
