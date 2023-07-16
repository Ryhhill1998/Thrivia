//
//  User.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

struct User: Identifiable {
    let id: String
    var username: String
    var email: String
    let password = "**********"
    var iconColour: Color
}
