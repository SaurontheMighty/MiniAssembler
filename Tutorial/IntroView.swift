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
            FirstLineView()
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

struct Swipe: View {
    var body: some View {
        Text("Swipe →")
            .foregroundColor(.deepPurple)
            .font(.system(size: 15))
            .bold()
            .padding(.bottom, 30)
    }
}
