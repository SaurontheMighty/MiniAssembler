//
//  WhatIsAssemblyView.swift
//  Assembly
//
//  Created by Ashish Selvaraj on 2023-04-18.
//

import SwiftUI

struct WhatIsAssemblyView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            VStack {
                Spacer()
                Text("What Is Assembly?")
                    .bold()
                    .font(.title)
                    .foregroundColor(.deepPurple)
                Spacer()
                
                    
                BasicText(text: "Assembly is still readable by humans but it can take much longer to write than your average programming language.")
                
                Group {
                    Spacer()
                    Card(content: SimpleProgram(), title: "A Simple Assembly Instruction", minHeight: 0)
                        .frame(height: 100)
                    Spacer()
                    Card(content: MachineCode(), title: "Here's that in Machine Code", minHeight: 0)
                        .frame(height: 100)
                    Spacer()
                }
                
                Group {
                    
                    BasicText(text: "When you hit run on your code in a high level programming language like Swift, the compiler optimizes it and translates it to assembly which is then assembled (converted to 1s and 0s).")
                }
            }
            .padding(.horizontal, 15)

            Spacer()

            HStack {
                Image("hanginthere")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                Spacer()
            }
                
            Spacer()
            Swipe()

        }
    }
}

struct WhatIsAssemblyView_Previews: PreviewProvider {
    static var previews: some View {
        WhatIsAssemblyView()
            .previewDevice("iPhone 14")
    }
}

struct SimpleProgram: View {
    @State private var command: CommandType = add(args: ["5", "6", "7"])
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(command.name) ")
                .bold()
                .foregroundColor(.deepPurple)
            
            Line(command: command)
            
            Spacer()
        }
    }
}

struct MachineCode: View {
    var body: some View {
        Text("000000 00110 00111 00101 00000 100000")
            .font(.system(size: 14, design: .monospaced))
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
    }
}
