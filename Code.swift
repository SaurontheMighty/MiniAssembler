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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(state.code.enumerated()), id: \.offset) { (line, command) in
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
                        state.code.remove(at: line)
                    } label: {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                            
                    }
                    .padding(.trailing, 5)
                }
            }
            Spacer()
            HStack {
                Text(state.error)
                    .foregroundColor(.red)
                    .bold()
                Spacer()
                Button {
                    state.assemble()
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
    @State private var args: [Int] = []
    
    @State private var successful = false
    
    var body: some View {
        HStack(spacing: 0) {
            Text("(")
            ForEach(Array(help.enumerated()), id: \.offset) { index, arg in
                if index == 0 {
                    Text("$")
                        .bold()
                        .foregroundColor(.orange)
                }
                Blank(text: arg, send: { result in
                    args.append(result)
                    var command: CommandType = state.code[line]
                    if args.count == command.arity {
                        do {
                            try command.fill(args: args)
                            print("Succeeded")
                        }
                        catch {
                            print("FAILED")
                        }
                    }                })
                if index < help.count - 1 {
                    Text(", ")
                }
            }
            Text(")")
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
                    .foregroundColor(.orange)
            }
            else {
                TextField("", text: $text)
                    .foregroundColor(textColor)
                    .keyboardType(.numberPad)
                    .onReceive(Just(text)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) && !" \n\t\r".contains($0) }
                        if filtered != newValue && filtered[0] != "0" && filtered != "" && Int(filtered)! > 0 && Int(filtered)! < 29 {
                            self.text = filtered
                        }
                    }
                    .border(.orange, width: 1)
            }
            
            if !filled {
                Button {
                    let filtered = text.filter { "0123456789".contains($0) && !" \n\t\r".contains($0) }
                    if filtered != "" && filtered[0] != "0" && Int(filtered)! > 0 && Int(filtered)! < 29 {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                        filled = true
                        
                        send(Int(text)!)
                    }
                    else {
                        textColor = .red
                    }
                } label: {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.orange)
                }
                .padding(.leading, 1)
            }
        }
    }
}

struct Line: View {
    @State var args: [Int]
    
    var body: some View {
        HStack(spacing: 0) {
            Text("(")
            ForEach(Array(args.enumerated()), id: \.offset) { index, arg in
                if index == 0 {
                    Text("$")
                        .bold()
                        .foregroundColor(.orange)
                }
                Text(String(arg))
                    .bold()
                    .foregroundColor(.orange)
                if index < args.count - 1 {
                    Text(", ")
                }
            }
            Text(")")
        }
    }
}
