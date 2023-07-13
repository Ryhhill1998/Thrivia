//
//  UserIcon.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 13/07/2023.
//

import SwiftUI

struct UserIcon: View {
    var body: some View {
        Text("Z")
            .foregroundColor(.white)
            .font(.custom("Montserrat", size: 25))
            .bold()
            .frame(width: 75.0, height: 75.0)
            .background(.purple)
            .cornerRadius(37.5)
            .overlay {
                Circle()
                    .stroke(.white, lineWidth: 4)
            }
    }
}

struct UserIcon_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            UserIcon()
        }
    }
}
