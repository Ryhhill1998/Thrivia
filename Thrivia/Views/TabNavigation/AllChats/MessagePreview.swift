//
//  MessagePreview.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 13/07/2023.
//

import SwiftUI

struct MessagePreview: View {
    
    let name: String
    let backgroundColour: Color
    let lastMessage: String
    var editMode: Bool
    
    var body: some View {
        HStack {
            HStack(spacing: 15.0) {
                UserIcon(size: "medium", borderColour: .white, backgroundColour: backgroundColour, name: name)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(name)
                        .font(.custom("Montserrat", size: 17))
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Black"))
                    
                    Text(lastMessage)
                        .font(.custom("Montserrat", size: 13))
                        .lineLimit(1)
                        .foregroundColor(Color("Black"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            if editMode {
                Image(systemName: "trash")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("Black"))
                    .padding(.horizontal)
            }
        }
        .background(.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct MessagePreview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            MessagePreview(name: "ZigzagZebra24", backgroundColour: .purple, lastMessage: "That’s what thrivia is here for! What would you like to talk about?", editMode: false)
        }
    }
}
