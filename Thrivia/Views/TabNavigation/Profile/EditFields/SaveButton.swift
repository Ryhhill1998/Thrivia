//
//  SaveButton.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 04/08/2023.
//

import SwiftUI

struct SaveButton: View {
    
    let fetchStatus: String
    let action: () -> Void
    
    var body: some View {
        if fetchStatus == "pending" {
            ProgressButton(text: "Saving", foregroundColour: Color("White"), backgroundColour: Color("Green"))
        } else if fetchStatus == "idle" || fetchStatus == "failure" {
            ActionButton(text: "Save", fontColour: Color("White"), backgroundColour: Color("Green"), action: action)
        } else {
            HStack(spacing: 5.0) {
                Text("Saved")
                    .font(.custom("Montserrat", size: 20))
                    .foregroundColor(Color("White"))
                    .bold()
                
                Image(systemName: "checkmark.circle")
                    .foregroundColor(Color("White"))
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(Color("Green"))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}
