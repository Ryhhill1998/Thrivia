//
//  ThriviaApp.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 01/07/2023.
//

import SwiftUI
import Firebase

@main
struct ThriviaApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
