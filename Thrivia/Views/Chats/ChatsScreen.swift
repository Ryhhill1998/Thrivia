//
//  ChatsScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct ChatsScreen: View {
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Chats")
    }
}

struct ChatsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatsScreen()
    }
}
