//
//  AssemblerState.swift
//  Assembler
//
//  Created by Ashish Selvaraj on 2023-04-16.
//

import Foundation

class AssemblerState: ObservableObject {
    @Published var registers: [Int: Int] = [0: 0]
    @Published var labels: [String: Int] = [:]
    @Published var code: [CommandType] = []
    @Published var error: String = ""
    
    func assemble() {
        print("ASSEMBLING")
        print("ASSEMBLED")
    }
}

protocol CommandType {
    var name: String { get }
    var arity: Int { get }
    var args: [Int] { get }
    var help: [String] { get }
    var description: String { get }
    
    init()
    mutating func fill(args: [Int]) throws
    func execute() throws -> Int
}

enum CommandError: Error {
    case invalidArity
    case outOfBounds
}

struct add: CommandType {
    let name = "add"
    let arity = 3
    var args: [Int]
    let help = ["target", "a", "b"]
    let description = "target = a + b"
    
    init() {
        self.args = []
    }
    
    mutating func fill(args: [Int]) throws {
        if args.count != arity {
            throw CommandError.invalidArity
        }
        self.args = args
    }
    
    func execute() throws -> Int {
        guard args.count == arity else {
            throw CommandError.invalidArity
        }
        return args[1] + args[2]
    }
}
