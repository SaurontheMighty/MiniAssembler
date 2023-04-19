//
//  Registers.swift
//  Assembler
//
//  Created by Ashish Selvaraj on 2023-04-16.
//

import SwiftUI

struct Registers: View {
    @ObservedObject var state: AssemblerState
    @Binding var usedRegisters: [Int]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(usedRegisters, id:\.self) { index in
                    HStack(spacing: 0) {
                        Text("$\(index): ")
                            .foregroundColor(.purple)

                        Text("\(state.registers[index]!)")
                            .bold()
                            .foregroundColor(.darkOrange)
                    }
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(CardBackground())
                    .padding(.horizontal, 2)
                    .padding(.vertical, 5)
                }
            }
        }
    }
}
//
//struct Registers_Previews: PreviewProvider {
//    @State var reg: [Int] = [0,1,2,3]
//    
//    static var previews: some View {
//        Registers(state: AssemblerState(), usedRegisters: $reg)
//    }
//}
