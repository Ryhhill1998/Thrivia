//
//  ChatSettingsScreen.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 27/07/2023.
//

import SwiftUI

struct ChatSettingsScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showConfirmUnblockAlert = false
    @State var isActive = true
    
    var userId: String
    
    func backPressed() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            ScrollView {
                Toggle("Activity status", isOn: $isActive)
                    .font(.custom("Montserrat", size: 17))
                    .fontWeight(.medium)
                    .frame(height: 55)
                    .padding(.horizontal)
                    .background(Color("White"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 1)
                
                HStack {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(Color("Black"))
                    
                    Text("Blocked users")
                }
                .font(.custom("Montserrat", size: 17))
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 55)
                .padding(.horizontal)
                .background(Color("White"))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.top, 20)
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
                Text("Chat Settings")
                    .bold()
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct ChatSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatSettingsScreen(userId: "e7NhVK9n82Shd6UXyLDGzSuKqcD3")
    }
}
