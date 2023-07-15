//
//  ProgressScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct ProgressScreen: View {
    
    @StateObject var counterViewModel = CounterViewModel()
    
    @State var counterNotCreated: Bool
    @State var inEditMode: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                ScrollView {
                    Text("Tracked since 27 Jun 2023")
                        .font(.custom("Montserrat", size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(Color("Black"))
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                                
                                Text("Thriving since 27 Jun 2023")
                                    .font(.custom("Montserrat", size: 15))
                                    .foregroundColor(Color("Black"))
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity, alignment: .leading)
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
                        
                        ActionButton(text: "Edit counter", fontColour: .white, backgroundColour: Color("Green")) {
                            inEditMode = true
                        }
                        
                        ActionButton(text: "Reset counter", fontColour: Color("DarkGreen"), backgroundColour: Color("LightGreen")) {
                            print("resetting counter")
                        }
                    }
                }
            }
            .navigationTitle(counterViewModel.counterName ?? "Counter name")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbarBackground(Color("Background"), for: .navigationBar)
            .navigationDestination(isPresented: $counterNotCreated) {
                CreateCounterScreen(navigationTitle: "Create a counter", counterViewModel: counterViewModel, buttonActionDescription: "Create")
            }
            .navigationDestination(isPresented: $inEditMode) {
                CreateCounterScreen(navigationTitle: "Edit counter", counterViewModel: counterViewModel, buttonActionDescription: "Save")
            }
        }
    }
}

struct ProgressScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProgressScreen(counterNotCreated: true)
    }
}
