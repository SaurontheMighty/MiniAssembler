//
//  Commands.swift
//  Assembler
//
//  Created by Ashish Selvaraj on 2023-04-16.
//
import Foundation

// CommandType
//  All commands: add, sub, beq, bne are of protocol CommandType
//  args: Array of strings which represent the arguments given to the command
//      Strings are used because in reality registers can contain ANY four bytes of information
//      so this just makes it more extendable. Something like Hex can be implemented in the future.
//  help: Array containing helpful hints about what should go in each box.
//  description: Helpful information about the instruction
protocol CommandType {
    var name: String { get }
    var arity: Int { get }
    var args: [String] { get set }
    var help: [String] { get }
    var description: String { get }
    
    init()
    
    init(args: [String])
    
    func execute(registers: inout [Int: Int]) throws -> Bool
}

enum CommandError: Error {
    case invalidLabel
    case invalidArity
    case invalidRegister
    case outOfBounds
    case cannotAssignZero
    case incompleteDefinition
    case nonExecutableCommand
}

class add: CommandType {
    let name = "add"
    let arity = 3
    var args: [String] = []
    let help = ["$target", "$a", "$b"]
    let description = "target = value of register a + value of register b"
    
    required init() {}
    
    required convenience init(args: [String]) {
        self.init()
        self.args = args
    }
    
    func execute(registers: inout [Int: Int]) throws -> Bool {
        if args == [] {
            throw CommandError.incompleteDefinition
        }
        else if args.count != arity {
            throw CommandError.invalidArity
        }
        else if args[0] == "0" {
            throw CommandError.cannotAssignZero
        }
        else if !validRegister(reg: args[0]) || !validRegister(reg: args[1]) || !validRegister(reg: args[2]) {
            throw CommandError.invalidRegister
        }
        let target = Int(args[0])!
        let op1 = Int(args[1])!
        let op2 = Int(args[2])!
        
        registers[target] = registers[op1]! + registers[op2]!
        return true
    }
}

class sub: CommandType {
    let name = "sub"
    let arity = 3
    var args: [String] = []
    let help = ["$target", "$a", "$b"]
    let description = "target = value of register a - value of register b"
        
    required init() {}
    
    required convenience init(args: [String]) {
        self.init()
        self.args = args
    }
    
    func execute(registers: inout [Int: Int]) throws -> Bool {
        if args == [] {
            throw CommandError.incompleteDefinition
        }
        else if args.count != arity {
            throw CommandError.invalidArity
        }
        else if args[0] == "0" {
            throw CommandError.cannotAssignZero
        }
        else if !validRegister(reg: args[0]) || !validRegister(reg: args[1]) || !validRegister(reg: args[2]) {
            throw CommandError.invalidRegister
        }
        let target = Int(args[0])!
        let op1 = Int(args[1])!
        let op2 = Int(args[2])!
        
        registers[target] = registers[op1]! - registers[op2]!
        return true
    }
}

class li: CommandType {
    let name = "li"
    let arity = 2
    var args: [String] = []
    let help = ["$target", "value"]
    let description =
    """
        li: Load Immediate
        Example: li $target, value
        
        Loads the value into the target register.
    """
    
    required init() {}
    
    required convenience init(args: [String]) {
        self.init()
        self.args = args
    }
    
    func execute(registers: inout [Int: Int]) throws -> Bool {
        if args.count == 0 {
            throw CommandError.incompleteDefinition
        }
        else if args.count != arity {
            throw CommandError.invalidArity
        }
        else if args[0] == "0" {
            throw CommandError.cannotAssignZero
        }
        else if !validRegister(reg: args[0]) {
            throw CommandError.invalidRegister
        }
        let target = Int(args[0])!
        let value = Int(args[1])!
        
        registers[target] = value
        return true
    }
}

class label: CommandType {
    let name = "label"
    let arity = 1
    var args: [String] = []
    let help = ["name"]
    let description =
    """
        label: Adds a label to the line. Labels cannot start with a number but can contain numbers. For example n0fx is a valid label.
    
        Once a label is added, you can simply type the label name in beq/bne and when the condition is met the interpreter will jump to where ever the label is.
    """
    
    required init() {}
    
    required convenience init(args: [String]) {
        self.init()
        self.args = args
    }
    
    func execute(registers: inout [Int: Int]) throws -> Bool {
        guard let firstChar = args[0].first else { throw CommandError.invalidLabel }
        guard firstChar.isLetter || firstChar.isNumber else { throw CommandError.invalidLabel }
        
        return true
    }
}

class beq: CommandType {
    let name = "beq"
    let arity = 3
    var args: [String] = []
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
    
    required init() {}
    
    required convenience init(args: [String]) {
        self.init()
        self.args = args
    }
    
    func execute(registers: inout [Int: Int]) throws -> Bool {
        guard args.count == arity else {
            throw CommandError.invalidArity
        }
        guard validRegister(reg: args[0]) && validRegister(reg: args[1]) else {
            throw CommandError.invalidRegister
        }
        let op1 = Int(args[0])!
        let op2 = Int(args[1])!
        return registers[op1] == registers[op2]
    }
}

class bne: CommandType {
    let name = "bne"
    let arity = 3
    var args: [String] = []
    let help = ["$left", "$right", "skip"]
    let description =
    """
        BNE: Branch on Not Equal to
        Call: ($left, $right, skip)
    
        Skip can either be a label's name (in which case it would jump to where the label is) or it can be a number
        
        High Level Equivalent:
        if (left != right) {
            if skip is a label: jump to the label
            if skip is positive: jump to (skip + 1) lines ahead
            if skip is negative: jump to (skip + 1) lines behind
        }
    
        Description:
        Allows us to implement loops and skip to a different line conditionally.
    
        SIMPLIFICATION: In 'real' MIPS the offset is the number of bytes to offset by (every instruction is 4 bytes so it would be a factor of 4) but here it is simplified to be number of lines
    """
    
    required init() {}
    
    required convenience init(args: [String]) {
        self.init()
        self.args = args
    }
    
    func execute(registers: inout [Int: Int]) throws -> Bool {
        guard args.count == arity else {
            throw CommandError.invalidArity
        }
        guard validRegister(reg: args[0]) && validRegister(reg: args[1]) else {
            throw CommandError.invalidRegister
        }
        let op1 = Int(args[0])!
        let op2 = Int(args[1])!
        return registers[op1] != registers[op2]
    }
}

func validRegister(reg: String) -> Bool {
    let regi = Int(reg)

    if regi != nil && regi! >= 0 && regi! < 32 {
        return true
    }
    return false
}
