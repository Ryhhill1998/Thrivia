//
//  FormField.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 03/08/2023.
//

import SwiftUI

struct FormField: View {
    
    let fieldName: String
    @Binding var fieldText: String
    
    var body: some View {
        TextField(fieldName, text: $fieldText)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color("White"))
            .cornerRadius(10)
            .font(.custom("Montserrat", size: 18))
            .fontWeight(.medium)
            .foregroundColor(Color("Black"))
            .padding(.horizontal)
    }
}
