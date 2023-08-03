//
//  LinkText.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 03/08/2023.
//

import SwiftUI

struct LinkText: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom("Montserrat", size: 15))
            .foregroundColor(Color("Black"))
    }
}

struct LinkText_Previews: PreviewProvider {
    static var previews: some View {
        LinkText(text: "Don't have an account?")
    }
}
