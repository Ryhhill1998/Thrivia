//
//  FieldLabel.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 04/08/2023.
//

import SwiftUI

struct FieldLabel: View {
    
    let label: String
    
    var body: some View {
        Text(label)
            .foregroundColor(Color("Black"))
            .font(.custom("Montserrat", size: 15))
            .fontWeight(.semibold)
    }
}
