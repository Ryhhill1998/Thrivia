//
//  LinkButtonText.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 03/08/2023.
//

import SwiftUI

struct LinkButtonText: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom("Montserrat", size: 15))
            .fontWeight(.bold)
            .foregroundColor(Color("Black"))
    }
}

struct LinkButtonText_Previews: PreviewProvider {
    static var previews: some View {
        LinkButtonText(text: "Login")
    }
}
