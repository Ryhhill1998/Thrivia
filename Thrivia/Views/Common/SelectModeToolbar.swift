//
//  SelectModeToolbar.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 24/07/2023.
//

import SwiftUI

struct SelectModeToolbar: View {
    
    let selectedItems: Int
    let itemName: String
    let backgroundColour: Color
    let cancel: () -> Void
    let delete: () -> Void
    
    var body: some View {
        HStack {
            Button {
                cancel()
            } label: {
                Text("Cancel")
                    .font(.custom("Montserrat", size: 15))
                    .fontWeight(.medium)
            }
            
            Text("\(selectedItems) \(itemName)s selected")
                .font(.custom("Montserrat", size: 14))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)

            Button {
                delete()
            } label: {
                HStack(alignment: .center, spacing: 5) {
                    Text("Delete")
                        .font(.custom("Montserrat", size: 15))
                        .fontWeight(.medium)
                    
                    Image(systemName: "trash")
                }
                .foregroundColor(.red)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.bottom)
        .background(backgroundColour)
    }
}

struct SelectModeToolbar_Previews: PreviewProvider {
    
    static var previews: some View {
        SelectModeToolbar(selectedItems: 5, itemName: "message", backgroundColour: Color("Background"), cancel: {print("cancel")}, delete: {print("delete")})
    }
}
