//
//  CreateCounterScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import SwiftUI

struct CreateCounterScreen: View {
    
    @State private var currentDate = Date.now
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 10.0) {
                HStack {
                    TimeDisplay(value: 0, units: "Days")
                    TimeDisplay(value: 0, units: "Hours")
                    TimeDisplay(value: 0, units: "Minutes")
                    TimeDisplay(value: 0, units: "Seconds")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15.0) {
                    Text("Counter name")
                        .font(.custom("Montserrat", size: 18))
                        .foregroundColor(Color("Black"))
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color("Black").opacity(0.2))
                    
                    DatePicker(selection: $currentDate, in: ...Date.now, displayedComponents: .date) {
                        Text("Start date")
                            .font(.custom("Montserrat", size: 18))
                            .foregroundColor(Color("Black"))
                            .fontWeight(.semibold)
                    }
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color("Black").opacity(0.2))
                    
                    DatePicker(selection: $currentDate, in: ...Date.now, displayedComponents: .hourAndMinute) {
                        Text("Start time")
                            .font(.custom("Montserrat", size: 18))
                            .foregroundColor(Color("Black"))
                            .fontWeight(.semibold)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .cornerRadius(10)
                .padding()
                
                ActionButton(text: "Create counter", fontColour: Color("White"), backgroundColour: Color("Green")) {
                    print("creating counter")
                }
            }
        }
        .navigationTitle("Create a counter")
    }
}

struct CreateCounterScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateCounterScreen()
    }
}
