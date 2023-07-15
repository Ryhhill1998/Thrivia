//
//  AccountDetailField.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 15/07/2023.
//

import SwiftUI

struct AccountDetailField: View {
    
    let fieldName: String
    let fieldValue: String
    
    var body: some View {
        HStack {
            Text(fieldName)
                .foregroundColor(Color("Black"))
                .font(.custom("Montserrat", size: 18))
                .fontWeight(.semibold)
            
            Text(fieldValue)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(Color("Black"))
                .font(.custom("Montserrat", size: 15))
            
            Button {
                print("edit mode")
            } label: {
                Image(systemName: "chevron.right")
            }
        }
    }
}

struct AccountDetailField_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailField(fieldName: "Username", fieldValue: "ZigzagZebra24")
    }
}
