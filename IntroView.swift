//
//  IntroView.swift
//  Assembler
//
//  Created by Ashish Selvaraj on 2023-04-17.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        TabView {
            Welcome()
            WhatIsAssembly()
            ThisProject()
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(Color(.systemGroupedBackground))
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
            .previewDevice("iPhone 14")
    }
}

struct Welcome: View {
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Spacer()
            Text("Mini Assembler")
                .bold()
                .font(.title)
                .foregroundColor(.deepPurple)
                .padding(.bottom, 16)
            Spacer()
            
            Group {
                BasicText(text: "Programming can sometimes feel like magic 🎩🪄\n")

                BasicText(text: "Writing a couple lines of code can unlock remarkable things and do complex calculations.")
            }
            Spacer()

//            Text("01001000 01101001 00001010")
//                .foregroundColor(.deepPurple)
//                .bold()
//                .padding(.vertical, 10)
//                .padding(.horizontal, 15)
//                .background(CardBackground())
//                .padding(10)
//
            Image("compy")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
            Spacer()

            Group {
                BasicText(text: "But we know that computers only understand binary, so how does this work?\n")
                
                BasicText(text: "This project hopes to pique your interest in assembly and the remarkable things that happen when you hit run on your program.")
            }
            Spacer()

            Text("Swipe →")
                .foregroundColor(.deepPurple)
                .font(.system(size: 15))
                .bold()
        }
        .padding(.horizontal, 15)
    }
}

struct BasicText: View {
    @State var text: String
    
    var body: some View {
        Text(text)
            .font(.callout)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 15)
    }
}

struct WhatIsAssembly: View {
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Spacer()
            Text("What Is Assembly?")
                .bold()
                .font(.title)
                .foregroundColor(.deepPurple)
                .padding(.bottom, 16)
            Spacer()
            
            Group {
                BasicText(text: "Assembly can be thought of as one step above pure machine code (0s and 1s). It's still readable by humans but it can take much longer to write than your average programming language.\n")
                
                BasicText(text: "Most languages have compilers that take your code in a high level programming language (like Swift, Python or C++), optimizes and translates it to assembly.")
            }

            Group {
                Spacer()
                BasicText(text: "Here's a simple assembly program:")
                Text("01001000 01101001 00001010")
                    .foregroundColor(.deepPurple)
                    .bold()
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(CardBackground())
                    .padding(10)
                
                BasicText(text: "Here's that in machine code:")
                Text("01001000 01101001 00001010")
                    .foregroundColor(.deepPurple)
                    .bold()
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(CardBackground())
                    .padding(10)
                Spacer()
            }
            
            Group {
                BasicText(text: "Assembly can be thought of as one step above pure machine code (0s and 1s). It's still readable by humans but it can take much longer to write than your average programming language.\n")
                
                BasicText(text: "Most languages have compilers that take your code in a high level programming language (like Swift, Python or C++), optimizes and translates it to assembly.")
            }

            Text("Swipe →")
                .foregroundColor(.deepPurple)
                .font(.system(size: 15))
                .bold()
        }
        .padding(.horizontal, 15)
    }
}

struct ThisProject: View {
    @State private var registers: [Int] = []

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Spacer()
            Text("What Is Assembly?")
                .bold()
                .font(.title)
                .foregroundColor(.deepPurple)
                .padding(.bottom, 16)
            Spacer()
            
            Group {
                BasicText(text: "Assemblers translate the assembly code to machine code. This project doesn't actually 'assemble' your code (convert it to 0s and 1s) but simulates the experience of running an assembly program.\n")
                
                BasicText(text: "There are many flavours of assembly, this project allows you to write code with a very small and restricted subset of MIPS assembly.")
            }

            Group {
                Spacer()
                Registers(state: AssemblerState(), usedRegisters: $registers)
                Spacer()
            }

            Group {
                BasicText(text: "Processors typically have registers that allow for small amounts of very fast storage. This project simulates a system with 32 registers. \n")
                
                BasicText(text: "Each register can store 4 bytes of information which translates to being able to store numbers between 2^32 - 1 and 2^32. This project restricts the values they can hold to positive numbers. \n")
            }
            
            Spacer()

            Text("Swipe →")
                .foregroundColor(.deepPurple)
                .font(.system(size: 15))
                .bold()
        }
        .padding(.horizontal, 15)
        .onAppear {
            for v in 0..<32 {
                registers.append(v)
            }
        }
    }
}
