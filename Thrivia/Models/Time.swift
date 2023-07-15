//
//  Time.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import Foundation

struct Time: Identifiable {
    var id = UUID().uuidString
    let unit: String
    let value: Int
}
