//
//  EditIconColour.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 22/07/2023.
//

import SwiftUI

struct EditIconColour: View {
    
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var selectedColour: String
    
    func setSelectedColour(colour: String) {
        selectedColour = colour
    }
    
    func updateIconColour() {
        profileViewModel.updateUserIconColour(newIconColour: selectedColour)
    }
    
    func backPressed() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 15.0) {
                VStack(spacing: 20.0) {
                    HStack(spacing: 20.0) {
                        ForEach((1...3), id: \.self) {
                            IconColourButton(iconColour: "IconColour\($0)", selected: selectedColour == "IconColour\($0)", action: setSelectedColour(colour:))
                        }
                    }
                    
                    HStack(spacing: 20.0) {
                        ForEach((4...6), id: \.self) {
                            IconColourButton(iconColour: "IconColour\($0)", selected: selectedColour == "IconColour\($0)", action: setSelectedColour(colour:))
                        }
                    }
                }
                .padding()
                .background(Color("White"))
                .cornerRadius(10)
                .padding(.horizontal)
                
                if profileViewModel.fetchStatus == "pending" {
                    ProgressButton(text: "Saving", foregroundColour: Color("White"), backgroundColour: Color("Green"))
                } else if profileViewModel.fetchStatus == "idle" || profileViewModel.fetchStatus == "failure" {
                    ActionButton(text: "Save", fontColour: Color("White"), backgroundColour: Color("Green"), action: updateIconColour)
                } else {
                    HStack(spacing: 5.0) {
                        Text("Saved")
                            .font(.custom("Montserrat", size: 20))
                            .foregroundColor(Color("White"))
                            .bold()
                        
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(Color("White"))
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(Color("Green"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.top, 20.0)
        }
        .alert(profileViewModel.errorTitle, isPresented: $profileViewModel.errorExists, actions: {
            Button("Okay", role: .cancel) {}
        }, message: {
            Text(profileViewModel.errorMessage)
        })
        .onDisappear() {
            profileViewModel.resetFetchStatus()
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    backPressed()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("Black"))
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Edit Icon Colour")
                    .bold()
            }
        }
        .toolbar(.visible, for: .navigationBar)
    }
}

struct EditIconColour_Previews: PreviewProvider {
    static var previews: some View {
        EditIconColour(selectedColour: "IconColour1")
            .environmentObject(ProfileViewModel())
    }
}

struct IconColourButton: View {
    
    let iconColour: String
    let selected: Bool
    let action: (String) -> Void
    
    var body: some View {
        Button {
            action(iconColour)
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
