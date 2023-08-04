//
//  ConfirmationAlert.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 04/08/2023.
//

import SwiftUI

struct ConfirmationAlert: View {
    
    let title: String
    let message: String
    let confirmButtonText: String
    @Binding var presentationBind: Bool
    let action: () -> Void
    
    var body: some View {
        ZStack {
            
        }
        .alert(title, isPresented: $presentationBind, actions: {
            Button(confirmButtonText, role: .destructive) {
                action()
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text(message)
        })
    }
}
