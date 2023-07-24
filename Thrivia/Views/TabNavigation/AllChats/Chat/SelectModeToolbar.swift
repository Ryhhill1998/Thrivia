//
//  SelectModeToolbar.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 24/07/2023.
//

import SwiftUI

struct SelectModeToolbar: View {
    
    let messagesSelected: Int
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
            
            Text("\(messagesSelected) messages selected")
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
        .padding(.top)
        .background(Color("Background"))
    }
}

struct SelectModeToolbar_Previews: PreviewProvider {
    
    static var previews: some View {
        SelectModeToolbar(messagesSelected: 5, cancel: {print("cancel")}, delete: {print("delete")})
    }
}
