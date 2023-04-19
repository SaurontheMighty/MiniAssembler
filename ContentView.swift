import SwiftUI

struct ContentView: View {
    @StateObject var assemblerState: AssemblerState = AssemblerState(command: add())
    @State var usedRegisters: [Int] = [0]
    @State var introShowing = true
        
    var body: some View {
        ScrollView {
            Card(content: Code(state: assemblerState, hideClear: false, used: { used in
                print(used)
                usedRegisters = used
            }), title: "Mini Assembly", trailingTitle: "[MIPS]", minHeight: 300)
            
            VStack(alignment: .leading, spacing: 3) {
                Command(command: add(), send: { tapped in
                    assemblerState.code.append(add())
                })
                Command(command: sub(), send: { tapped in
                    assemblerState.code.append(sub())
                })
                Command(command: li(), send: { tapped in
                    assemblerState.code.append(li())
                })
                Command(command: label(), send: { tapped in
                    assemblerState.code.append(label())
                })
                Command(command: beq(), send: { tapped in
                    assemblerState.code.append(beq())
                })
                Command(command: bne(), send: { tapped in
                    assemblerState.code.append(bne())
                })
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 5)
            .padding(.horizontal, 10)
            
            Card(content: Registers(state: assemblerState, usedRegisters: $usedRegisters), title: "Registers", minHeight: 0)
            
            ChallengesView(state: assemblerState)

            HStack {
                VStack (alignment: .leading) {
                    Text("Made by Ashish Selvaraj")
                        .font(.system(size: 14, design: .monospaced))
                    Text("Swift Student Challenge '23")
                        .font(.system(size: 14, design: .monospaced))
                }
                Button {
                    introShowing = true
                } label: {
                    NiceButtonView(text: "Re-launch Introduction", icon: "line.diagonal.arrow", bgColor: .black)
                }
            }
            .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $introShowing) {
            IntroView()
                .preferredColorScheme(.light)
        }
    }
}

// Contains the Challenges
struct ChallengesView: View {
    @ObservedObject var state: AssemblerState
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Challenges")
                .bold()
                .foregroundColor(.deepPurple)
            Challenge(state: state, text: "Create an infinite loop!", code: [
                label(args: ["start"]),
                beq(args: ["0", "0", "start"]),
            ])
            Challenge(state: state, text: "Set $15 to 0 and keep adding 1 in a loop until the value in $15 = 5", code: [
                li(args: ["1", "1"]),
                li(args: ["15", "0"]),
                li(args: ["5", "5"]),
                label(args: ["start"]),
                beq(args: ["15", "5", "end"]),
                add(args: ["15", "15", "1"]),
                bne(args: ["15", "5", "start"]),
                label(args: ["end"])
            ])
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
}

struct Challenge: View {
    @ObservedObject var state: AssemblerState
    @State var text: String
    @State var code: [CommandType]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text(text)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Button {
                    state.deletedLines = []
                    state.code = code
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                } label: {
                    NiceButtonView(text: "Solution", icon: "", bgColor: .blue)
                }
            }
            Text("Tapping 'Solution' overwrites whatever you've already written!")
                .font(.caption)
                .foregroundColor(.red)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(CardBackground())
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
        .frame(maxWidth: .infinity, alignment: .leading)
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


