//
//  EditIconColour.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 22/07/2023.
//

import SwiftUI

struct EditIconColour: View {
    
    var selectedColour: String
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 15.0) {
                VStack(spacing: 20.0) {
                    HStack(spacing: 20.0) {
                        ForEach((1...3), id: \.self) {
                            IconColourButton(iconColour: "IconColour\($0)", selected: selectedColour == "IconColour\($0)")
                        }
                    }
                    
                    HStack(spacing: 20.0) {
                        ForEach((4...6), id: \.self) {
                            IconColourButton(iconColour: "IconColour\($0)", selected: selectedColour == "IconColour\($0)")
                        }
                    }
                }
                .padding()
                .background(Color("White"))
                .cornerRadius(10)
                .padding(.horizontal)
                
                ActionButton(text: "Save", fontColour: Color("White"), backgroundColour: Color("Green")) {
                    print("click")
                }
            }
        }
    }
}

struct EditIconColour_Previews: PreviewProvider {
    static var previews: some View {
        EditIconColour(selectedColour: "IconColour1")
    }
}

struct IconColourButton: View {
    
    let iconColour: String
    let selected: Bool
    
    var body: some View {
        Button {
            print("button clicked")
        } label: {
            Circle()
                .foregroundColor(Color(iconColour))
                .overlay {
                    if selected {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                            .foregroundColor(Color("White"))
                    }
                }
        }
    }
}
