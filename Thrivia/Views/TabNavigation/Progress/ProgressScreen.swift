//
//  ProgressScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct ProgressScreen: View {
    
    @StateObject var counterViewModel = CounterViewModel()
    
    @State var inEditMode: Bool = false
    @State var showResetAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                ScrollView {
                    DescriptionText(text: "Tracked since \(counterViewModel.getFormattedOriginalStartDate())")
                        .padding(.leading)
                        .padding(.bottom, 15)
                    
                    VStack(spacing: 15.0) {
                        VStack(spacing: 15.0) {
                            VStack(spacing: 5.0) {
                                Text("Current run")
                                    .font(.custom("Montserrat", size: 20))
                                    .foregroundColor(Color("Black"))
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                DescriptionText(text: "Thriving since  \(counterViewModel.getFormattedRunStartDate())")
                            }
                            
                            HStack {
                                TimeDisplay(value: counterViewModel.timeValue1, units: counterViewModel.timeUnits1)
                                TimeDisplay(value: counterViewModel.timeValue2, units: counterViewModel.timeUnits2)
                                TimeDisplay(value: counterViewModel.timeValue3, units: counterViewModel.timeUnits3)
                                TimeDisplay(value: counterViewModel.timeValue4, units: counterViewModel.timeUnits4)
                            }
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        ActionButton(text: "Edit counter", fontColour: .white, backgroundColour: Color("Green")) { inEditMode = true }
                        
                        ActionButton(text: "Reset counter", fontColour: Color("DarkGreen"), backgroundColour: Color("LightGreen")) { showResetAlert = true }
                        
                        ConfirmationAlert(title: "Reset Counter", message: "Are you sure you want to reset your counter", confirmButtonText: "Reset", presentationBind: $showResetAlert, action: counterViewModel.resetCounter)
                    }
                }
            }
            .navigationTitle(counterViewModel.counterName)
            .navigationBarTitleDisplayMode(.automatic)
            .toolbarBackground(Color("Background"), for: .navigationBar)
            .navigationDestination(isPresented: $counterViewModel.counterNotCreated) {
                CreateCounterScreen()
                    .environmentObject(counterViewModel)
            }
            .navigationDestination(isPresented: $inEditMode) {
                EditCounterScreen(counterName: counterViewModel.counterName, startDate: counterViewModel.getCounterStart())
                    .environmentObject(counterViewModel)
            }
        }
        .onAppear() {
            counterViewModel.loadCounter()
        }
        .accentColor(Color("Black"))
    }
}

struct ProgressScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProgressScreen()
    }
}
