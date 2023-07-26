//
//  EditCounter.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 26/07/2023.
//

import SwiftUI

struct EditCounter: View {
    
    @StateObject var counterViewModelPreview = CounterViewModel(preview: true)
    
    @EnvironmentObject var counterViewModel: CounterViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDate: Date
    @State var counterName: String
    @State private var showEmptyNameAlert = false
    
    init(counterName: String, startDate: Date) {
        _counterName = State(initialValue:  counterName)
        _selectedDate = State(initialValue: startDate)
    }
    
    func createCounterPreview(name: String, startDate: Date) {
        counterViewModelPreview.generatePreview(name: name, startDate: startDate)
    }
    
    func saveCounter() {
        if counterName.isEmpty {
            showEmptyNameAlert = true
        } else {
            counterViewModel.editCounter(newName: counterName, newStart: selectedDate)
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
                
                ActionButton(text: "Save counter", fontColour: Color("White"), backgroundColour: Color("Green")) {
                    saveCounter()
                }
                
                Spacer()
            }
            .onChange(of: selectedDate) { newDate in
                createCounterPreview(name: counterName, startDate: newDate)
            }
            .padding(.top)
        }
        .navigationTitle("Edit Counter")
        .toolbar(.hidden, for: .tabBar)
    }
}

struct EditCounter_Previews: PreviewProvider {
    static var previews: some View {
        EditCounter(counterName: "Counter Name", startDate: Date.now)
    }
}
