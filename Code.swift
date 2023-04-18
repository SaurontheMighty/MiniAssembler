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
                var command = state.code[line]
                HStack(spacing: 0) {
                    Group {
                        Text("\(line)")
                            .font(.system(size: 14, design: .monospaced))
                            .foregroundColor(.gray)
                            .padding(.trailing, 3)
                        Text("\(command.name) ")
                            .bold()
                            .foregroundColor(state.deletedLines.contains(line) ? .gray : .deepPurple)
                    }
                    
                    if(state.deletedLines.contains(line)) {
                        DeletedLine(help: command.help, arity: command.arity)
                    }
                    else if command.args == [] {
                        EmptyCommand(state: state, line: line, help: command.help)
                    }
                    else {
                        Line(help: command.help, args: command.args)
                    }
                    if command.name == "label" {
                        Text(":")
                            .bold()
                            .foregroundColor(.darkOrange)
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        state.code[line].args = []
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                            .opacity(state.deletedLines.contains(line) ? 0 : 1)
                    }
                    .padding(.trailing, 2)
                    
                    Button {
                        if state.deletedLines.contains(line) {
                            state.deletedLines.remove(line)
                        }
                        else {
                            state.deletedLines.insert(line)
                        }
                    } label: {
                        Image(systemName: state.deletedLines.contains(line) ? "arrowshape.turn.up.backward.circle.fill" : "x.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.red)
                            
                    }
                    .padding(.trailing, 2)
                }
                
            }
            Spacer()
            BottomBar(state: state, used: { usedRegs in
                used(usedRegs)
            })
        }
    }
}

struct EmptyCommand: View {
    @ObservedObject var state: AssemblerState
    @State var line: Int
    @State var help: [String]
    @State private var args: [Int: String] = [:]
    
    @State private var successful = false
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(help.enumerated()), id: \.offset) { index, arg in
                let isRegister = arg[0] == "$"
                if isRegister {
                    Text("$")
                        .bold()
                        .foregroundColor(.darkOrange)
                }
                Blank(text: isRegister ? arg.substring(fromIndex: 1) : arg, isRegister: isRegister, send: { result in
                    args[index] = result
                    var command: CommandType = state.code[line]
                    if args.keys.count == command.arity {
                        for key in args.keys.sorted(by: <) {
                            let val = args[key]!
                            command.args.append(val)
                        }
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                })
                if index < help.count - 1 {
                    Text(", ")
                }
            }
        }
    }
}

struct Blank: View {
    @State var text: String
    
    @State private var filled = false
    @State private var textColor: Color = .primary
    @State var isRegister: Bool = false
    let send: (String) -> Void

    
    var body: some View {
        HStack (spacing: 0) {
            if filled {
                Text(text)
                    .foregroundColor(.darkOrange)
            }
            else {
                TextField("", text: $text)
                    .foregroundColor(textColor)
                    .keyboardType(isRegister ? .numberPad : .numbersAndPunctuation)
                    .onReceive(Just(text)) { newValue in
                        if (isRegister && validRegister(text)) {
                            let filtered = text.filter { "-0123456789".contains($0) && !" \n\t\r".contains($0) }
                            self.text = filtered
                        }
                        else if !isRegister {
                            self.text = text
                        }
                    }
                    .border(Color.darkOrange, width: 1)
            }
            
            if !filled {
                Button {
                    if (isRegister && validRegister(text)) {
                        let filtered = text.filter { "-0123456789".contains($0) && !" \n\t\r".contains($0) }
                        filled = true
                        send(filtered)
                    }
                    else if !isRegister {
                        filled = true
                        send(text)
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
    
    func validRegister(_ text: String) -> Bool {
        print("valid register? \(text)")
        
        let filtered = text.filter { "-0123456789".contains($0) && !" \n\t\r".contains($0) }
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
    @State var help: [String]
    @State var args: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(args.enumerated()), id: \.offset) { index, arg in
                if help[index][0] == "$" {
                    Text("$")
                        .bold()
                        .foregroundColor(.darkOrange)
                }
                Text(arg)
                    .bold()
                    .foregroundColor(.darkOrange)
                if index < args.count - 1 {
                    Text(", ")
                }
            }
        }
    }
}

struct DeletedLine: View {
    @State var help: [String]
    @State var arity: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<arity, id: \.self) { index in
                if help[index][0] == "$" {
                    Text("$")
                        .foregroundColor(.gray)
                }
                Text("_")
                    .bold()
                    .foregroundColor(.gray)
                if index < arity - 1 {
                    Text(", ")
                }
            }
        }
    }
}

struct BottomBar: View {
    @ObservedObject var state: AssemblerState
    let used: ([Int]) -> Void
    
    var body: some View {
        HStack {
            Text(state.assemblyError)
                .foregroundColor(.red)
                .bold()
            Spacer()
            VStack(alignment: .trailing) {
                Button {
                    state.code = []
                    state.deletedLines = []
                } label: {
                    NiceButtonView(text: "Clear", icon: "trash.fill", bgColor: .orange)
                }
                Button {
                    used(state.assemble())
                } label: {
                    NiceButtonView(text: "Assemble", icon: "play.fill", bgColor: .green)
                }
            }
        }
        .padding(.trailing, 5)
    }
}

struct NiceButtonView: View {
    @State var text: String
    @State var icon: String
    @State var bgColor: Color
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Text(text)
                .bold()
                .foregroundColor(.white)
            Image(systemName: icon)
                .foregroundColor(.white)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(bgColor)
        )
    }
}
