//
//  ProfileScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct ProfileScreen: View {
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack {
                ZStack {
                    UserIconWithOverlay(size: "xLarge", borderColour: .white, backgroundColour: .purple, name: "ZigzagZebra24", overlayImage: Image(systemName: "plus"), overlayColour: Color("LightGreen"))
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
