//
//  AvailableUser.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 27/07/2023.
//

import SwiftUI

struct AvailableUser: View {
    
    let backgroundColour: Color
    let name: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ActiveUserIcon(size: "large", borderColour: .white, backgroundColour: backgroundColour, name: name)
            
            Text(name)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 65.0, height: 30, alignment: .top)
                .font(.custom("Montserrat", size: 12))
                .fontWeight(.medium)
                .foregroundColor(Color("Black"))
        }
    }
}

struct AvailableUser_Previews: PreviewProvider {
    static var previews: some View {
        AvailableUser(backgroundColour: Color("IconColour1"), name: "Ryan")
    }
}
