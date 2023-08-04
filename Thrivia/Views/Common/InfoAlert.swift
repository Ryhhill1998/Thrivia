//
//  InfoAlert.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 04/08/2023.
//

import SwiftUI

struct InfoAlert: View {
    
    let title: String
    let message: String
    @Binding var presentationBind: Bool
    
    var body: some View {
        ZStack {
            
        }
        .alert(title, isPresented: $presentationBind, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(message)
        })
    }
}
