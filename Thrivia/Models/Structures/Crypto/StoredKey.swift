//
//  StoredKey.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 20/07/2023.
//

import Foundation

struct StoredKey: Codable {
    let messageNumber: Int
    let key: Data
    let rawEphemeralKey: Data
}
