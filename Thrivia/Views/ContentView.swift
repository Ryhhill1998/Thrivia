//
//  ContentView.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 01/07/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationTab()
            .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
