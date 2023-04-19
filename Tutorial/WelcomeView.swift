//
//  WelcomeView.swift
//  Assembly
//
//  Created by Ashish Selvaraj on 2023-04-18.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Spacer()
            Text("Mini Assembly Interpreter")
                .bold()
                .font(.title)
                .foregroundColor(.deepPurple)
                .padding(.bottom, 16)
            Spacer()
            
            Group {
                BasicText(text: "Programming can sometimes feel like magic 🎩\n")

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
                .frame(width: 250, height: 100)
            Spacer()

            Group {
                BasicText(text: "But we know that computers only understand binary, so how does this work?\n")
                
                BasicText(text: "This project hopes to pique your interest in assembly and the remarkable things that happen when you hit run on your program.\n")
                
                BasicText(text: "Assembly can be thought of as one step above pure machine code (0s and 1s).")
            }
            Spacer()

            Swipe()
        }
        .padding(.horizontal, 15)
    }
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
