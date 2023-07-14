//
//  MessageBubble.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import SwiftUI

struct MessageBubble: View {
    
    let message: Message
    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: message.sent ? .trailing : .leading) {
            HStack {
                Text(message.content)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .foregroundColor(Color(message.sent ? "DarkGreen" : "White"))
                    .fontWeight(.semibold)
                    .background(Color(message.sent ? "LightGreen" : "Green"))
                    .cornerRadius(15)
                    .frame(maxWidth: 300, alignment: message.sent ? .trailing : .leading)
            }
            .frame(maxWidth: .infinity, alignment: message.sent ? .trailing : .leading)
            .padding(message.sent ? .trailing : .leading)
            .onTapGesture {
                showTime.toggle()
            }
            
            if showTime {
                Text("\(message.sent ? "Sent" : "Received") at \(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption)
                    .padding(message.sent ? .trailing : .leading)
            }
        }
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message(id: "1", content: "Hello there! What is your favourite colour?", sent: true, timestamp: Date()))
    }
}
