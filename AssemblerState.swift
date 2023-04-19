//
//  AssemblerState.swift
//  Assembler
//
//  Created by Ashish Selvaraj on 2023-04-16.
//

import Foundation

// The Class that controls the state of the interpreter
//  registers: Map containing the value of each register
//  labels: Map containing the position of every label
//  code: Array containing the lines of code
//  assemblyError: The error that is displayed in the UI
//  stdout: If stdout was available it would get updated here
//  deletedLines: A Set containing all deleted lines for fast lookup
class AssemblerState: ObservableObject {
    @Published var registers: [Int: Int] = [:]
    @Published var labels: [String: Int] = [:]
    @Published var code: [CommandType] = []
    @Published var assemblyError: String = ""
    @Published var stdout: String = ""
    @Published var deletedLines: Set<Int> = []
    
    init() {
        for val in 0..<32 {
            self.registers[val] = 0
        }
    }
    
    convenience init(command: CommandType) {
        self.init()
        self.code.append(command)
    }

 
    func assemble() -> [Int] {
        assemblyError = ""
        var usedRegistersSet: Set<Int> = []
        var labels: [String: Int] = [:]
        var index = 0
        var counter = 0
        
        for (index, instruction) in code.enumerated() {
            print("\(index) \(instruction)")
            if instruction.name == "label" && !deletedLines.contains(index) {
                if instruction.args.count == 0 { // empty label
                    assemblyError = "Tried to execute instruction without completing definition"
                    return []
                }
                else if !labels.contains(where: { $0.key == instruction.args[0] }) { // labels doesn't already have that element
                    labels[instruction.args[0]] = index
                }
                else {
                    assemblyError = "Label name already exists!"
                    return []
                }
            }
        }
        
        while index < code.count {
            counter += 1
            
            if counter == 100 {
                assemblyError = "Infinite Loop detected!"
                break
            }
            
            let command = code[index]
            if deletedLines.contains(index) {
                index += 1
                continue
            }
            
            do {
                print(command.name)
                print(command.arity)
                print(command.args)
                let result = try command.execute(registers: &registers)
                
                var registersUsedInCommand: [Int] = []
                
                let arity = command.arity
                let args = command.args
                let help = command.help
                for i in 0..<arity {
                    if (help[i][0] == "$") {
                        registersUsedInCommand.append(Int(args[i])!)
                    }
                }
                
                usedRegistersSet.formUnion(Set(registersUsedInCommand))
                
                if(command.name == "beq" || command.name == "bne") {
                    if result {
                        let skip = command.args.last!
                        let skipi = Int(skip)
                        if skipi == nil {
                            if labels.contains(where: { $0.key == skip }) {
                                index = labels[skip]!
                            }
                            else {
                                assemblyError = "Label \(skip) does not exist"
                                break
                            }
                        }
                        else {
                            index += skipi! + 1
                        }
                    }
                    else {
                        index += 1
                    }
                }
                else {
                    index += 1
                }
            }
            catch CommandError.cannotAssignZero {
                assemblyError = "Cannot assign $0! [Reserved Register]"
                break
            }
            catch CommandError.invalidRegister {
                assemblyError = "Register does not exist"
                break
            }
            catch CommandError.outOfBounds {
                assemblyError = "Number is out of bounds!"
                break
            }
            catch CommandError.invalidArity {
                assemblyError = "Tried to execute instruction with incorrect number of arguments"
                break
            }
            catch CommandError.incompleteDefinition {
                assemblyError = "Tried to execute instruction without completing definition"
                break
            }
            catch CommandError.nonExecutableCommand {
                assemblyError = "Tried to execute a instruction that cannot be executed"
                break
            }
            catch CommandError.invalidLabel {
                assemblyError = "Invalid Label!"
                break
            }
            catch {
                assemblyError = "Something went wrong"
                break
            }
        }
        
        let usedRegisters = Array(usedRegistersSet)
        return usedRegisters.sorted()
    }
}
