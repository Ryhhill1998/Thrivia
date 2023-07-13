//
//  ProgressScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 12/07/2023.
//

import SwiftUI

struct ProgressScreen: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(Color("DarkGreen"))]
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.init(Color("DarkGreen"))]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                ScrollView {
                    Text("Tracked since 27 Jun 2023")
                        .font(.custom("Montserrat", size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(Color("DarkGreen"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    
                    VStack(spacing: 10.0) {
                        VStack(spacing: 25.0) {
                            VStack(spacing: 5.0) {
                                Text("Current run")
                                    .font(.custom("Montserrat", size: 20))
                                    .bold()
                                    .foregroundColor(Color("DarkGreen"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("Thriving since 27 Jun 2023")
                                    .font(.custom("Montserrat", size: 15))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("DarkGreen"))
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
                        .padding()
                        
                        VStack(spacing: 20.0) {
                            ActionButton(text: "Edit counter", fontColour: .white, backgroundColour: Color("Green")) {
                                print("editing counter")
                            }
                            
                            ActionButton(text: "Reset counter", fontColour: Color("DarkGreen"), backgroundColour: Color("LightGreen")) {
                                print("resetting counter")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Alcohol")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbarBackground(Color("Background"), for: .navigationBar)
        }
    }
}

struct ProgressScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProgressScreen()
    }
}

struct TimeDisplay: View {
    
    let value: Int
    let units: String
    
    var body: some View {
        VStack(spacing: 7.0) {
            Text("\(value)")
                .font(.custom("Montserrat", size: 25))
                .bold()
                .foregroundColor(Color("DarkGreen"))
            
            Text(units)
                .font(.custom("Montserrat", size: 15))
                .fontWeight(.semibold)
                .foregroundColor(Color("DarkGreen"))
        }
        .frame(maxWidth: .infinity)
    }
}
