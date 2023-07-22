//
//  EditEmail.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 22/07/2023.
//

import SwiftUI

struct EditEmail: View {
    
    @State var newFieldValue = ""
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 15.0) {
                VStack(spacing: 15.0) {
                    HStack {
                        Text("Current email")
                            .foregroundColor(Color("Black"))
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.semibold)
                        
                        Text("ZigzagZebra24@mail.com")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(Color("Black"))
                            .font(.custom("Montserrat", size: 15))
                    }
                    
                    LineSeparator()
                    
                    HStack {
                        Text("New email")
                            .foregroundColor(Color("Black"))
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.semibold)
                        
                        TextField("Email address", text: $newFieldValue)
                            .multilineTextAlignment(.trailing)
                            .font(.custom("Montserrat", size: 15))
                            .fontWeight(.medium)
                            .foregroundColor(Color("Black"))
                    }
                }
                .padding()
                .background(Color("White"))
                .cornerRadius(10)
                .padding(.horizontal)
                
                ActionButton(text: "Save", fontColour: Color("White"), backgroundColour: Color("Green")) {
                    print("hello")
                }
                
                Spacer()
            }
        }
    }
}

struct EditEmail_Previews: PreviewProvider {
    static var previews: some View {
        EditEmail()
    }
}
