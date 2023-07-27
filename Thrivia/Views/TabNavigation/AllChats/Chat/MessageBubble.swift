//
//  MessageBubble.swift
//  Thrivia
//
//  Created by Ryan Henzell-Hill on 14/07/2023.
//

import SwiftUI

struct MessageBubble: View {
    
    let message: Message
    let showTime: Bool
    let isSelectMode: Bool
    let isSelected: Bool
    let messageSelected: (String) -> Void
    
    var backgroundColour: Color {
        Color(message.sent ? "LightGreen" : "Green")
    }
    
    var foregroundColour: Color {
        Color(message.sent ? "DarkGreen" : "White")
    }
    
    var alignment: Alignment {
        message.sent ? .trailing : .leading
    }
    
    var paddingEdge: Edge.Set {
        message.sent ? .trailing : .leading
    }
    
    var oppositePaddingEdge: Edge.Set {
        message.sent ? .leading : .trailing
    }
    
    var body: some View {
        VStack(alignment: message.sent ? .trailing : .leading) {
            HStack {
                if isSelectMode && !message.sent {
                    Button {
                        messageSelected(message.id)
                    } label: {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color("Green"))
                    }
                    .padding(oppositePaddingEdge, -15)
                    .padding(paddingEdge, 10)
                }
                
                Text(message.content)
                    .font(.custom("Montserrat", size: 15))
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .foregroundColor(foregroundColour)
                    .fontWeight(.medium)
                    .background(backgroundColour)
                    .cornerRadius(15)
                    .frame(maxWidth: 300, alignment: message.sent ? .trailing : .leading)
                    .frame(maxWidth: .infinity, alignment: alignment)
                    .padding(paddingEdge)
                
                if isSelectMode && message.sent {
                    Button {
                        messageSelected(message.id)
                    } label: {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color("Green"))
                    }
                    .padding(oppositePaddingEdge, -15)
                    .padding(paddingEdge, 10)
                }
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
        MessageBubble(message: Message(id: "1", content: "Hello there! What is your favourite colour?", sent: false, read: true, timestamp: Date()), showTime: false, isSelectMode: true, isSelected: false) { print($0) }
    }
}
