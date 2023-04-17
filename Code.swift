//
//  Code.swift
//  Assembler
//
//  Created by Ashish Selvaraj on 2023-04-16.
//

import SwiftUI
import Combine

struct Code: View {
    @ObservedObject var state: AssemblerState
    let used: ([Int]) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<state.code.count, id: \.self) { line in
                let command = state.code[line]
                if(!state.deletedLines.contains(line)) {
                    HStack(spacing: 0) {
                        Text(command.name)
                            .bold()
                            .foregroundColor(.deepPurple)
                        if command.args == [] {
                            EmptyCommand(state: state, line: line, help: command.help)
                        }
                        else {
                            Line(args: command.args)
                        }
                        Spacer()
                        Button {
                            state.code[line].args = []
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                
                        }
                        .padding(.trailing, 5)
                        Button {
                            state.deletedLines.insert(line)
                        } label: {
                            Image(systemName: "trash.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.red)
                                
                        }
                        .padding(.trailing, 5)
                    }
                }
            }
            Spacer()
            HStack {
                Text(state.assemblyError)
                    .foregroundColor(.red)
                    .bold()
                Spacer()
                Button {
                    used(state.assemble())
                } label: {
                    HStack(alignment: .center, spacing: 4) {
                        Text("Assemble")
                            .bold()
                            .foregroundColor(.white)
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.green)
                    )
                }
            }
            .padding(.trailing, 5)
        }
    }
}

struct EmptyCommand: View {
    @ObservedObject var state: AssemblerState
    @State var line: Int
    @State var help: [String]
    @State private var args: [Int: Int] = [:]
    
    @State private var successful = false
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(help.enumerated()), id: \.offset) { index, arg in
                if index == 0 {
                    Text("$")
                        .bold()
                        .foregroundColor(.darkOrange)
                }
                Blank(text: arg, send: { result in
                    args[index] = result
                    var command: CommandType = state.code[line]
                    if args.keys.count == command.arity {
                        for key in args.keys.sorted(by: <) {
                            command.args.append(args[key]!)
                        }
                    }                })
                if index < help.count - 1 {
                    Text(", ")
                }
            }
        }
    }
}

struct Blank: View {
    @State var text: String
    
    let send: (Int) -> Void
    @State private var filled = false
    @State private var textColor: Color = .primary
    
    var body: some View {
        HStack (spacing: 0) {
            if filled {
                Text(text)
                    .foregroundColor(.darkOrange)
            }
            else {
                TextField("", text: $text)
                    .foregroundColor(textColor)
                    .keyboardType(.numberPad)
                    .onReceive(Just(text)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) && !" \n\t\r".contains($0) }
                        if validRegister(filtered) {
                            self.text = filtered
                        }
                    }
                    .border(Color.darkOrange, width: 1)
            }
            
            if !filled {
                Button {
                    let filtered = text.filter { "0123456789".contains($0) && !" \n\t\r".contains($0) }
                    if validRegister(filtered) {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                        filled = true
                        
                        send(Int(text)!)
                    }
                    else {
                        textColor = .red
                    }
                } label: {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.darkOrange)
                }
                .padding(.leading, 1)
            }
        }
    }
    
    func validRegister(_ filtered: String) -> Bool {
        if filtered.count > 1 && filtered[0] == "0" {
            return false
        }
        else if filtered == "" {
            return false
        }
        else if Int(filtered)! < 0 || Int(filtered)! > 29 {
            return false
        }
        return true
    }
}

struct Line: View {
    @State var args: [Int]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(args.enumerated()), id: \.offset) { index, arg in
                if index == 0 {
                    Text("$")
                        .bold()
                        .foregroundColor(.darkOrange)
                }
                Text(String(arg))
                    .bold()
                    .foregroundColor(.darkOrange)
                if index < args.count - 1 {
                    Text(", ")
                }
            }
        }
    }
}
