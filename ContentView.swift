import SwiftUI

struct ContentView: View {
    @StateObject var assemblerState: AssemblerState = AssemblerState()
    @State var usedRegisters: [Int] = [0]
    @State var introShowing = true
        
    var body: some View {
        ScrollView {
            Card(content: Code(state: assemblerState, used: { used in
                print(used)
                usedRegisters = used
            }), title: "Mini Assembler", trailingTitle: "[MIPS]", minHeight: 400)
            
            HStack(spacing: 3) {
                Command(command: add(), send: { tapped in
                    assemblerState.code.append(tapped)
                })
                Command(command: li(), send: { tapped in
                    assemblerState.code.append(tapped)
                })
            }
            .padding(.top, 5)
            
            Card(content: Registers(state: assemblerState, usedRegisters: $usedRegisters), title: "Registers", minHeight: 0)
//            Card(content: Help(), title: "Help", minHeight: 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $introShowing) {
            IntroView()
                .preferredColorScheme(.light)
        }
    }
}

struct Test: View {
    var body: some View {
        Text("Hi")

    }
}

struct Card<Content: View>: View {
    var content: Content
    @State var title: String
    @State var trailingTitle: String = ""
    @State var minHeight: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .bold()
                    .foregroundColor(.deepPurple)
                Spacer()
                Text(trailingTitle)
                    .bold()
                    .foregroundColor(.deepPurple)
            }
            VStack(alignment: .leading) {
                content
                Spacer()
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: minHeight)
            .background(CardBackground())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
}

struct CardBackground: View {
    @State var bgColor: Color = .cardGrey

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(bgColor)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
        
    }
}


