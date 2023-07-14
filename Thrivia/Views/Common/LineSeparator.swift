//
//  LineSeparator.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import SwiftUI

struct LineSeparator: View {
    var body: some View {
        Divider()
            .frame(height: 1)
            .background(Color("Black").opacity(0.2))
    }
}

struct LineSeparator_Previews: PreviewProvider {
    static var previews: some View {
        LineSeparator()
    }
}
