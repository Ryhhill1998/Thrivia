//
//  ProgressScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct ProgressScreen: View {
    
    @State var counterNotCreated: Bool
    
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
                                TimeDisplay(value: 1, units: "Day")
                                TimeDisplay(value: 18, units: "Hours")
                                TimeDisplay(value: 20, units: "Minutes")
                                TimeDisplay(value: 59, units: "Seconds")
                            }
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        ActionButton(text: "Edit counter", fontColour: .white, backgroundColour: Color("Green")) {
                            print("editing counter")
                        }
                        
                        ActionButton(text: "Reset counter", fontColour: Color("DarkGreen"), backgroundColour: Color("LightGreen")) {
                            print("resetting counter")
                        }
                    }
                }
            }
            .navigationTitle("Alcohol")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbarBackground(Color("Background"), for: .navigationBar)
            .navigationDestination(isPresented: $counterNotCreated) {
                CreateCounterScreen()
            }
        }
    }
}

struct ProgressScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProgressScreen(counterNotCreated: false)
    }
}
