//
//  ChatOptions.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 24/07/2023.
//

import SwiftUI

struct ChatOptions: View {
    
    @EnvironmentObject private var chatViewModel: ChatViewModel
    
    @State var showConfirmBlockAlert = false
    
    let userId: String
    let backgroundColour: Color
    let name: String
    
    func blockUser() {
        chatViewModel.blockUser(userIdToBlock: userId)
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 15) {
                    UserIcon(size: "xLarge", borderColour: Color("White"), backgroundColour: backgroundColour, name: name)
                    
                    Text(name)
                        .font(.custom("Montserrat", size: 20))
                        .fontWeight(.semibold)
                }
                
                VStack(spacing: 15) {
                    Button {
                        showConfirmBlockAlert = true
                    } label: {
                        HStack(alignment: .center) {
                            Image(systemName: "minus.circle.fill")
                            
                            Text("Block user")
                                .font(.custom("Montserrat", size: 17))
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color("White"))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .alert("Block", isPresented: $showConfirmBlockAlert, actions: {
                        Button("Block", role: .destructive) {
                            blockUser()
                        }
                        
                        Button("Cancel", role: .cancel) {}
                    }, message: {
                        Text("Are you sure you want to block this user?")
                    })
                }
                
                Spacer()
            }
            .padding(.top)
        }
    }
}

struct ChatOptions_Previews: PreviewProvider {
    static var previews: some View {
        ChatOptions(userId: "1", backgroundColour: Color("IconColour1"), name: "ZigzagZebra24")
    }
}