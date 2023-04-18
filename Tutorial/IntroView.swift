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
            WelcomeView()
            WhatIsAssemblyView()
            ThisProjectView()
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

struct GettingStarted: View {
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
                ScrollView(.horizontal) {
                    HStack {
                        Registers(state: AssemblerState(), usedRegisters: $registers)
                    }
                    .frame(height: 50)
                }
                Spacer()
            }

            Group {
                BasicText(text: "Processors typically have registers that allow for small amounts of very fast storage. This project simulates a system with 32 registers. \n")
                
                BasicText(text: "Each register can store 4 bytes of information which translates to being able to store numbers between 2^32 - 1 and 2^32. This project restricts the values they can hold to positive numbers. \n")
            }
            
            Spacer()

            Swipe()

        }
        .padding(.horizontal, 15)
        .onAppear {
            for v in 0..<32 {
                registers.append(v)
            }
        }
    }
}

struct Swipe: View {
    var body: some View {
        Text("Swipe →")
            .foregroundColor(.deepPurple)
            .font(.system(size: 15))
            .bold()
            .padding(.bottom, 30)
    }
}
