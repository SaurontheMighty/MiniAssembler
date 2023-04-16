//
//  Code.swift
//  Assembler
//
//  Created by Ashish Selvaraj on 2023-04-16.
//

import SwiftUI

struct Code: View {
    @ObservedObject var state: AssemblerState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(state.code, id: \.self) { command in
                HStack(spacing: 0) {
                    Text(command.name)
                        .bold()
                        .foregroundColor(.deepPurple)
                    Text("(")
                    ForEach(Array(command.args.enumerated()), id: \.offset) { index, arg in
                        if index == 0 {
                            Text("$")
                                .bold()
                                .foregroundColor(.orange)
                        }
                        Text(String(arg))
                            .bold()
                            .foregroundColor(.orange)
                        if index < command.args.count - 1 {
                            Text(", ")
                        }
                    }
                    Text(")")
                    Spacer()
//                    Button {
//                        state.code.remove(at: line)
//                    } label: {
//                        Image(systemName: "trash.fill")
//                            .foregroundColor(.red)
//                    }
                }
            }
        }
    }
}

struct Code_Previews: PreviewProvider {
    static var previews: some View {
        Code(commands: [])
    }
}

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
