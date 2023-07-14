//
//  CreateCounterScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import SwiftUI

struct CreateCounterScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var counterViewModel: CounterViewModel
    
    @State private var selectedDate = Date.now
    @State private var selectedTime = Date.now
    
    @State var counterName = ""
    
    func createCounter() {
        print("Creating counter")
        
        counterViewModel.createCounter(name: counterName, startDate: selectedDate, startTime: selectedTime)
        
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 25) {
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
                
                VStack(alignment: .leading, spacing: 0) {
                    TextField("Counter name", text: $counterName)
                        .padding(.vertical, 15)
                        .background(.white)
                        .cornerRadius(10)
                        .font(.custom("Montserrat", size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(Color("Black"))
                    
                    LineSeparator()
                    
                    DatePicker(selection: $selectedDate, in: ...Date.now, displayedComponents: .date) {
                        Text("Start date")
                            .font(.custom("Montserrat", size: 18))
                            .foregroundColor(Color("Black"))
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 15)
                    
                    LineSeparator()
                    
                    DatePicker(selection: $selectedTime, in: ...Date.now, displayedComponents: .hourAndMinute) {
                        Text("Start time")
                            .font(.custom("Montserrat", size: 18))
                            .foregroundColor(Color("Black"))
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 15)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                ActionButton(text: "Create counter", fontColour: Color("White"), backgroundColour: Color("Green")) {
                    createCounter()
                }
                
                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("Create a counter")
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct CreateCounterScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateCounterScreen(counterViewModel: CounterViewModel())
    }
}
