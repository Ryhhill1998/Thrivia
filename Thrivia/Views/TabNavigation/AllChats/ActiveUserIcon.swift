//
//  ActiveUserIcon.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 13/07/2023.
//

import SwiftUI

struct ActiveUserIcon: View {
    
    let size: String
    let borderColour: Color
    let backgroundColour: Color
    let name: String
    
    var body: some View {
        UserIconWithOverlay(size: size, borderColour: borderColour, backgroundColour: backgroundColour, name: name, overlayImage: nil, overlayColour: .green)
    }
}

struct ActiveUserIcon_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            ActiveUserIcon(size: "xLarge", borderColour: .white, backgroundColour: .purple, name: "ZigzagZebra24")
        }
    }
}
