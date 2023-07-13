//
//  UserIcon.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 13/07/2023.
//

import SwiftUI

struct UserIcon: View {
    
    let size: String
    let borderColour: Color
    
    var width: CGFloat {
        if size == "large" {
            return 70.0
        } else if size == "medium" {
            return 50.0
        }
        
        return 50.0
    }
    
    var body: some View {
        Text("Z")
            .foregroundColor(.white)
            .font(.custom("Montserrat", size: 25))
            .bold()
            .frame(width: width, height: width)
            .background(.purple)
            .cornerRadius(width / 2)
            .overlay {
                Circle()
                    .stroke(borderColour, lineWidth: 4)
            }
    }
}

struct UserIcon_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            UserIcon(size: "large", borderColour: .white)
        }
    }
}
