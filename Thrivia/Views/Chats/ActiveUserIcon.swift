//
//  ActiveUserIcon.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 13/07/2023.
//

import SwiftUI

struct ActiveUserIcon: View {
    
    let size: String
    
    var body: some View {
        ZStack {
            UserIcon(size: size, borderColour: .white)
            
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.green)
                .overlay {
                    Circle()
                        .stroke(.white, lineWidth: 2)
                }
                .offset(x: 22, y: 22)
        }
    }
}

struct ActiveUserIcon_Previews: PreviewProvider {
    static var previews: some View {
        ActiveUserIcon(size: "large")
    }
}
