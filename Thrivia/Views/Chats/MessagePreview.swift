//
//  MessagePreview.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 13/07/2023.
//

import SwiftUI

struct MessagePreview: View {
    var body: some View {
        HStack(spacing: 15.0) {
            UserIcon(size: "medium", borderColour: .white, backgroundColour: .purple, name: "ZigzagZebra24")
            
            VStack(alignment: .leading, spacing: 5) {
                Text("ZigzagZebra24")
                    .font(.custom("Montserrat", size: 17))
                    .fontWeight(.semibold)
                
                Text("That’s what thrivia is here for! What would you like to talk about?")
                    .font(.custom("Montserrat", size: 13))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct MessagePreview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            MessagePreview()
        }
    }
}
