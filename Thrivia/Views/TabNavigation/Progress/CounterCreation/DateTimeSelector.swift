//
//  DateTimeSelector.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 03/08/2023.
//

import SwiftUI

struct DateTimeSelector: View {
    
    @Binding var selectedDate: Date
    let minDate = Calendar.current.date(byAdding: .year, value: -50, to: Date.now)!
    let type: String
    
    var body: some View {
        DatePicker(selection: $selectedDate, in: minDate...Date.now, displayedComponents: type == "date" ? .date : .hourAndMinute) {
            Text("Start \(type)")
                .font(.custom("Montserrat", size: 18))
                .foregroundColor(Color("Black"))
                .fontWeight(.semibold)
        }
        .padding(.vertical, 15)
    }
}
