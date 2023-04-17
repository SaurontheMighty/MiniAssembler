//
//  Command.swift
//  Assembler
//
//  Created by Ashish Selvaraj on 2023-04-16.
//

import SwiftUI

struct Command: View {
    @State var command: CommandType
    @State private var help: Bool = false
    
    let send: (Bool) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 0) {
                Button {
                    send(true)
                } label: {
                    HStack(spacing: 0) {
                        Text(command.name)
                            .bold()
                            .foregroundColor(.white)
                            
                        Text("(")
                            .foregroundColor(.white)
                        ForEach(0..<command.arity, id: \.self) { index in
                            Text(command.help[index])
                                .bold()
                                .foregroundColor(.white)
                            if index < command.arity - 1 {
                                Text(", ")
                                    .foregroundColor(.white)
                            }
                        }
                        Text(")")
                            .foregroundColor(.white)
                    }
                }
            
                Button {
                    help.toggle()
                } label: {
                    Image(systemName: help ? "questionmark.circle.fill" : "questionmark.circle")
                        .foregroundColor(.white)
                        .padding(.leading, 5)
                }
            }
            if help {
                Text(command.description)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(CardBackground(bgColor: .purple))
    }
}
