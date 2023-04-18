//
//  AssemblerState.swift
//  Assembler
//
//  Created by Ashish Selvaraj on 2023-04-16.
//

import Foundation

class AssemblerState: ObservableObject {
    @Published var registers: [Int: Int] = [:]
    @Published var labels: [String: Int] = [:]
    @Published var code: [CommandType] = [
        add()
    ]
    @Published var assemblyError: String = ""
    @Published var stdout: String = ""
    @Published var deletedLines: Set<Int> = []
    
    init() {
        for val in 0..<32 {
            registers[val] = 0
        }

    }
    
    func assemble() -> [Int] {
        assemblyError = ""
        var usedRegistersSet: Set<Int> = []
        var index = 0
        
        while index < code.count {
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
                
                usedRegistersSet.formUnion(Set(command.args))
                
                if(command.name == "beq") {
                    if result {
                        index += command.args.last! + 1
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
                assemblyError = "Tried to execute command with incorrect number of arguments"
                break
            }
            catch CommandError.incompleteDefinition {
                assemblyError = "Tried to execute command without completing definition"
                break
            }
            catch CommandError.nonExecutableCommand {
                assemblyError = "Tried to execute a command that cannot be executed"
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

protocol CommandType {
    var name: String { get }
    var arity: Int { get }
    var args: [Int] { get set }
    var help: [String] { get }
    var description: String { get }
    
    func execute(registers: inout [Int: Int]) throws -> Bool
}

