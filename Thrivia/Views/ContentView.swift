//
//  ContentView.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 01/07/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        NavigationTab()
            .preferredColorScheme(.light)
            .environmentObject(authenticationViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
