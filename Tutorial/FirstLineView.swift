//
//  FirstLineView.swift
//  Assembly
//
//  Created by Ashish Selvaraj on 2023-04-18.
//

import SwiftUI

struct FirstLineView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var state = AssemblerState()
    @State private var registers = [5, 6, 7]
    @State private var tapSequence = 1
    @State private var amazing = false
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            VStack {
                Text("Write Some Assembly!")
                    .bold()
                    .font(.title)
                    .foregroundColor(.deepPurple)
                    .padding(.top, 22)
                
                Spacer()
                
                Group {
                    BasicText(text: "Let's try and write an assembly instruction to place the value 5 in the register $5")
                }
                
                Spacer()

                Group {
                    Card(content: Code(state: state, hideClear: true, used: { used in
                        if state.registers[5] == 5 && state.assemblyError == "" {
                            amazing = true
                        }
                    }), title: "Try it!", minHeight: 0)
                        .frame(height: 200)
                    
                    Card(content: Registers(state: state, usedRegisters: $registers), title: "Registers", minHeight: 0)
                        .frame(height: 90)
                    HStack {
                        if tapSequence == 2 {
                            Text("👉🏼")
                        }
                        Command(command: li(), send: { send in
                            state.code.append(li())
                        })
                        if tapSequence == 2 {
                            Text("👈🏼")
                        }
                    }
                }
            }
            .padding(.horizontal, 15)
            
            Spacer()
            if (tapSequence == 1) {
                HStack {
                    Spacer()
                    Text("Tap me 👇🏼")
                        .bold()
                        .padding(.trailing, 20)
                }
            }
            HStack {
                Image(getImage(amazing: amazing, tap: tapSequence))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                Spacer()
                
                if !amazing {
                    Button {
                        tapSequence += 1
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 25, weight: .black))
                            .foregroundColor(.deepPurple)
                            .padding(.trailing, 20)
                    }
                }
            }
            
            Spacer()
                
            Button{
                dismiss()
                let impactMed = UIImpactFeedbackGenerator(style: .soft)
                impactMed.impactOccurred()
            } label: {
                Text("Open Interpreter")
                    .font(.system(size: 17))
                    .bold()
                    .padding(EdgeInsets.init(top: 12, leading: 44, bottom: 12, trailing: 44))
                    .foregroundColor(Color.white)
                    .frame(maxWidth:.infinity)
                    .background(Color.deepPurple)
                    .cornerRadius(15)
                    .padding([.horizontal, .bottom], 25)
            }

        }
    }
    
    func getImage(amazing: Bool, tap: Int) -> String {
        if amazing {
            return "amazing"
        }
        
        switch tap {
        case 1: return "step1"
        case 2: return "step2"
        case 3: return "step3"
        case 4: return "step4"
        default: return "step5"
        }
    }
}

struct FirstLineView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLineView()
            .previewDevice("iPhone 14")
    }
}
