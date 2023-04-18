//
//  Commands.swift
//  Assembler
//
//  Created by Ashish Selvaraj on 2023-04-16.
//
import Foundation

enum CommandError: Error {
    case invalidArity
    case invalidRegister
    case outOfBounds
    case cannotAssignZero
    case incompleteDefinition
    case nonExecutableCommand
}

class add: CommandType {
    var label = ""
    let name = "add"
    let arity = 3
    var args: [Int] = []
    let help = ["$target", "$a", "$b"]
    let description = "target = value of register a + value of register b"
    
    func execute(registers: inout [Int: Int]) throws -> Bool {
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
        return true
    }
}

class sub: CommandType {
    var label = ""
    let name = "sub"
    let arity = 3
    var args: [Int] = []
    let help = ["$target", "$a", "$b"]
    let description = "target = value of register a - value of register b"
    
    func execute(registers: inout [Int: Int]) throws -> Bool {
        if args == [] {
            throw CommandError.incompleteDefinition
        }
        else if args.count != arity {
            throw CommandError.invalidArity
        }
        else if args[0] == 0 {
            throw CommandError.cannotAssignZero
        }
        registers[args[0]] = registers[args[1]]! - registers[args[2]]!
        return true
    }
}

class li: CommandType {
    var label = ""
    let name = "li"
    let arity = 2
    var args: [Int] = []
    let help = ["$target", "value"]
    let description = "target = value"
    
    func execute(registers: inout [Int: Int]) throws -> Bool {
        guard args.count == arity else {
            throw CommandError.invalidArity
        }
        guard args[0] != 0 else {
            throw CommandError.cannotAssignZero
        }
        registers[args[0]] = args[1]
        return true
    }
}

class beq: CommandType {
    var label = ""
    let name = "beq"
    let arity = 3
    var args: [Int] = []
    let help = ["$left", "$right", "skip"]
    let description =
    """
        BEQ: Branch on Equal to
        Call: ($left, $right, skip)
        
        High Level Equivalent:
        if (left == right) { jump to (skip - 1) lines ahead }
    
        Description:
        Allows us to implement loops and skip to a different line conditionally.
    
        SIMPLIFICATION: In 'real' MIPS the offset is the number of bytes to offset by (every instruction is 4 bytes so it would be a factor of 4) but here it is simplified to be number of lines
    """
    
    func execute(registers: inout [Int: Int]) throws -> Bool {
        guard args.count == arity else {
            throw CommandError.invalidArity
        }
        guard validRegister(reg: args[0]) && validRegister(reg: args[1]) else {
            throw CommandError.invalidRegister
        }
        return registers[args[0]] == registers[args[1]]
    }
}

class bne: CommandType {
    var label = ""
    let name = "bne"
    let arity = 3
    var args: [Int] = []
    let help = ["$left", "$right", "skip"]
    let description =
    """
        BNE: Branch on Not Equal to
        Call: ($left, $right, skip)
        
        High Level Equivalent:
        if (left != right) {
            if skip is positive: jump to (skip + 1) lines ahead
            if skip is negative: jump to (skip + 1) lines behind
        }
    
        Description:
        Allows us to implement loops and skip to a different line conditionally.
    
        SIMPLIFICATION: In 'real' MIPS the offset is the number of bytes to offset by (every instruction is 4 bytes so it would be a factor of 4) but here it is simplified to be number of lines
    """
    
    func execute(registers: inout [Int: Int]) throws -> Bool {
        guard args.count == arity else {
            throw CommandError.invalidArity
        }
        guard validRegister(reg: args[0]) && validRegister(reg: args[1]) else {
            throw CommandError.invalidRegister
        }
        return registers[args[0]] == registers[args[1]]
    }
}

func validRegister(reg: Int) -> Bool {
    if reg >= 0 && reg < 28 {
        return true
    }
    return false
}
