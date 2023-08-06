//
//  CreateCounterScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import SwiftUI

struct CreateCounterScreen: View {
    
    @StateObject var counterViewModelPreview = CounterViewModel()
    
    @EnvironmentObject var counterViewModel: CounterViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDate = Date.now
    @State var counterName = ""
    @State private var showEmptyNameAlert = false
    
    func createCounterPreview(name: String, startDate: Date) {
        counterViewModelPreview.generatePreview(name: name, startDate: startDate)
    }
    
    func createCounter() {
        let counterCreated = counterViewModel.createCounter(name: counterName, startDate: selectedDate)
        
        if counterCreated {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 25) {
                HStack {
                    TimeDisplay(value: counterViewModelPreview.timeValue1, units: counterViewModelPreview.timeUnits1)
                    TimeDisplay(value: counterViewModelPreview.timeValue2, units: counterViewModelPreview.timeUnits2)
                    TimeDisplay(value: counterViewModelPreview.timeValue3, units: counterViewModelPreview.timeUnits3)
                    TimeDisplay(value: counterViewModelPreview.timeValue4, units: counterViewModelPreview.timeUnits4)
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
                    
                    InfoAlert(title: counterViewModel.errorTitle, message: counterViewModel.errorMessage, presentationBind: $counterViewModel.errorExists)
                    
                    LineSeparator()
                    
                    DateTimeSelector(selectedDate: $selectedDate, type: "date")
                    
                    LineSeparator()
                    
                    DateTimeSelector(selectedDate: $selectedDate, type: "time")
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                ActionButton(text: "Create counter", fontColour: Color("White"), backgroundColour: Color("Green")) { createCounter() }
                
                Spacer()
            }
            .onChange(of: selectedDate) { newDate in
                createCounterPreview(name: counterName, startDate: newDate)
            }
            .padding(.top)
        }
        .navigationTitle("Create Counter")
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}
