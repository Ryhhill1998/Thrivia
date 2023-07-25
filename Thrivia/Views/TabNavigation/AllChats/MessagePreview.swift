//
//  MessagePreview.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 13/07/2023.
//

import SwiftUI

struct MessagePreview: View {
    
    let id: String
    let name: String
    let backgroundColour: Color
    let lastMessage: String
    let read: Bool
    let isSelectMode: Bool
    let isSelected: Bool
    let selectChat: (String) -> Void
    
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
                        .fontWeight(read ? .regular : .semibold)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            
            if isSelectMode {
                Button {
                    selectChat(id)
                } label: {
                    Circle()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color(isSelected ? "DarkGreen" : "Background"))
                        .overlay {
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("White"))
                        }
                }
                .padding(.leading, -10)
                .padding(.trailing, 15)
            }
        }
    }
}

struct MessagePreview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            MessagePreview(id: "1", name: "ZigzagZebra24", backgroundColour: .purple, lastMessage: "That’s what thrivia is here for! What would you like to talk about?", read: false, isSelectMode: true, isSelected: true) { print($0) }
        }
    }
}
