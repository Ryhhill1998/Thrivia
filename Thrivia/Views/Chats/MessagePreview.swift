//
//  MessagePreview.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 13/07/2023.
//

import SwiftUI

struct MessagePreview: View {
    var body: some View {
        HStack {
            UserIcon()
            
            VStack(alignment: .leading) {
                Text("ZigzagZebra24")
                
                Text("That’s what thrivia is here for! What would you like to talk about?")
            }
        }
    }
}

struct MessagePreview_Previews: PreviewProvider {
    static var previews: some View {
        MessagePreview()
    }
}
