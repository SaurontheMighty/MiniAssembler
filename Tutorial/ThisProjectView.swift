//
//  ThisProjectView.swift
//  Assembly
//
//  Created by Ashish Selvaraj on 2023-04-18.
//

import SwiftUI

struct ThisProjectView: View {
    @State private var registers: [Int] = []

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Spacer()
            Text("This Project")
                .bold()
                .font(.title)
                .foregroundColor(.deepPurple)
            Spacer()
            
            Group {
                BasicText(text: "This project allows you to write instructions with a small subset of MIPS assembly. Your assembly code is then interpreted, allowing you to see what it does.")
                
                BasicText(text: "Below is a visual respresentation of processor registers:")
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
                
                BasicText(text: "Each register can store 4 bytes of information. This project restricts the values they can hold to numbers. \n")
                
                BasicText(text: "Now you're ready to write your first line of assembly! \n")
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

struct ThisProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ThisProjectView()
            .previewDevice("iPhone 14")
    }
}
