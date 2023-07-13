//
//  TimeDisplay.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 13/07/2023.
//

import SwiftUI

struct TimeDisplay: View {
    
    let value: Int
    let units: String
    
    var body: some View {
        VStack(spacing: 7.0) {
            Text("\(value)")
                .font(.custom("Montserrat", size: 25))
                .bold()
            
            Text(units)
                .font(.custom("Montserrat", size: 15))
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TimeDisplay_Previews: PreviewProvider {
    static var previews: some View {
        TimeDisplay(value: 59, units: "Seconds")
    }
}
