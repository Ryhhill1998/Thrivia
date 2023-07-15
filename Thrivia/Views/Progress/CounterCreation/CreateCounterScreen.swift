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
    @ObservedObject var counterViewModelPreview: CounterViewModel = CounterViewModel()
    
    @State private var selectedDate = Date.now
    @State var counterName = ""
    
    @State private var showEmptyNameAlert = false
    
    func createCounter() {
        if counterName.isEmpty {
            showEmptyNameAlert = true
        } else {
            counterViewModel.createCounter(name: counterName, startDate: selectedDate)
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
                        .alert("Counter name cannot be empty", isPresented: $showEmptyNameAlert) {
                            Button("OK", role: .cancel) { }
                        }
                    
                    LineSeparator()
                    
                    DatePicker(selection: $selectedDate, in: ...Date.now, displayedComponents: .date) {
                        Text("Start date")
                            .font(.custom("Montserrat", size: 18))
                            .foregroundColor(Color("Black"))
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 15)
                    
                    LineSeparator()
                    
                    DatePicker(selection: $selectedDate, in: ...Date.now, displayedComponents: .hourAndMinute) {
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
            .onChange(of: selectedDate) { newDate in
                counterViewModelPreview.generatePreview(name: counterName, startDate: newDate)
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
