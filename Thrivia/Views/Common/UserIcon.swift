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
    let backgroundColour: Color
    let name: String
    
    var width: CGFloat {
        if size == "xLarge" {
            return 100.0
        } else if size == "large" {
            return 70.0
        } else if size == "medium" {
            return 50.0
        } else if size == "small" {
            return 35.0
        }
        
        return 50.0
    }
    
    var fontSize: CGFloat {
        if size == "xLarge" {
            return 40
        } else if size == "large" {
            return 28
        } else if size == "medium" {
            return 22
        } else if size == "small" {
            return 16.0
        }
        
        return 25.0
    }
    
    var borderWidth: CGFloat {
        return width / 18
    }
    
    var initial: String {
        return "\(name.prefix(1))"
    }
    
    var body: some View {
        Text(initial)
            .foregroundColor(Color("White"))
            .font(.custom("Montserrat", size: fontSize))
            .bold()
            .frame(width: width, height: width)
            .background(backgroundColour)
            .cornerRadius(width / 2)
            .overlay {
                Circle()
                    .stroke(borderColour, lineWidth: borderWidth)
            }
    }
}

struct UserIcon_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            UserIcon(size: "xLarge", borderColour: .white, backgroundColour: .purple, name: "ZigzagZebra24")
        }
    }
}
