//
//  AppIcon.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import SwiftUI

struct AppIcon: View {
    var body: some View {
        Image("AppIconNoBg")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100.0, height: 100.0)
    }
}

struct AppIcon_Previews: PreviewProvider {
    static var previews: some View {
        AppIcon()
    }
}
