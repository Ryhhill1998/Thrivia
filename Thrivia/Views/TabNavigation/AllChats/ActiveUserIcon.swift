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
    
    var diameter: CGFloat {
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
    
    var offset: CGFloat {
        return diameter / (2 * sqrt(2))
    }
    
    var borderWidth: CGFloat {
        return diameter / 25
    }
    
    var overlayWidth: CGFloat {
        return diameter * 0.3
    }
    
    var body: some View {
        ZStack {
            UserIcon(size: size, borderColour: borderColour, backgroundColour: backgroundColour, name: name)
            
            Circle()
                .frame(width: overlayWidth, height: overlayWidth)
                .foregroundColor(.green)
                .overlay {
                    Circle()
                        .stroke(.white, lineWidth: borderWidth)
                }
                .offset(x: offset, y: offset)
        }
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
