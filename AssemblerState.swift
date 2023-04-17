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
        for val in 0...29 {
            registers[val] = 0
        }
    }
    
    func assemble() -> [Int] {
        assemblyError = ""
        var usedRegistersSet: Set<Int> = []
        
        for (index, command) in code.enumerated() {
            if !deletedLines.contains(index) {
                do {
                    print(command.name)
                    print(command.arity)
                    print(command.args)
                    try command.execute(registers: &registers)
                    
                    usedRegistersSet.formUnion(Set(command.args))
                }
                catch CommandError.cannotAssignZero {
                    assemblyError = "Cannot assign $0! [Reserved Register]"
                }
                catch CommandError.outOfBounds {
                    assemblyError = "Number is out of bounds!"
                }
                catch CommandError.invalidArity {
                    assemblyError = "Tried to execute command with incorrect number of arguments"
                }
                catch CommandError.incompleteDefinition {
                    assemblyError = "Tried to execute command without completing definition"
                }
                catch {
                    assemblyError = "Something went wrong"
                }
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
    
    func execute(registers: inout [Int: Int]) throws
}

enum CommandError: Error {
    case invalidArity
    case outOfBounds
    case cannotAssignZero
    case incompleteDefinition
}

class add: CommandType {
    let name = "add"
    let arity = 3
    var args: [Int] = []
    let help = ["target", "a", "b"]
    let description = "target = a + b"
    
    func execute(registers: inout [Int: Int]) throws -> Void {
        if args == [] {
            throw CommandError.incompleteDefinition
        }
        else if args.count != arity {
            throw CommandError.invalidArity
        }
        else if args[0] == 0 {
            throw CommandError.cannotAssignZero
        }
        registers[args[0]] = registers[args[1]]! + registers[args[2]]!
    }
}

class li: CommandType {
    let name = "li"
    let arity = 2
    var args: [Int] = []
    let help = ["target", "value"]
    let description = "target = value"
    
    func execute(registers: inout [Int: Int]) throws -> Void {
        guard args.count == arity else {
            throw CommandError.invalidArity
        }
        guard args[0] != 0 else {
            throw CommandError.cannotAssignZero
        }
        registers[args[0]] = args[1]
    }
}
