//
//  CalculatorManager.swift
//  Calculator
//
//  Created by Daniel Garcia on 22/11/2017.
//  Copyright © 2017 CINQ. All rights reserved.
//

import Foundation

struct CalculatorManager {
    
    enum Operation{
        case unaryOperation((Double) -> (Double))
        case binaryOperation ((Double, Double) -> (Double))
        case perc ((Double, Double) -> (Double))
        case unknown
        case equals
    }
    
    private var accumulator: Double = 0
    private var binaryOperationMemory : PreviousBinaryOperation?
    private let operations = [
        "+":Operation.binaryOperation({$0 + $1}),
        "⨉":Operation.binaryOperation({$0 * $1}),
        "-":Operation.binaryOperation({$0 - $1}),
        "÷":Operation.binaryOperation({$0 / $1}),
        "√":Operation.unaryOperation(sqrt),
        "±":Operation.unaryOperation({$0 == 0 ? 0 : -$0}),
        "%":Operation.perc({($0 * $1)/100}),
        "=":Operation.equals
    ]
    
    private struct PreviousBinaryOperation {
        
        let function:(Double, Double) -> Double
        let firstOperand:Double
        let operation : String
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
        
    }
    
    var result: Double {
        get {
            return self.accumulator
        }
    }
    
    mutating func clear() {
        self.setOperand(0)
        self.binaryOperationMemory = nil
    }
    
    
    mutating func performOperation(_ symbol: String ) {
        guard let operation = operations[symbol] else { return }
        
        switch operation {
        case .binaryOperation(let op):
            if let memory = binaryOperationMemory {
                self.accumulator = memory.function(memory.firstOperand, self.accumulator)
                self.binaryOperationMemory = nil
            }
                binaryOperationMemory = PreviousBinaryOperation.init(function: op, firstOperand: self.accumulator, operation: symbol)
        case .unaryOperation(let op):
            self.accumulator = op(self.accumulator)
        case .perc(let op):
            if (binaryOperationMemory?.firstOperand) != nil{
                self.accumulator = op((binaryOperationMemory?.firstOperand)!, self.accumulator)
            }else{
                self.accumulator = op((1), self.accumulator)
            }
        case .equals:
            doPreviousBinaryOperation()
        default :
            break
        }
    }
    
    
    mutating func setOperand(_ operand: Double) {
        self.accumulator = operand
    }
    
    mutating func doPreviousBinaryOperation() {
        guard let memory = binaryOperationMemory else { return }
        self.accumulator = memory.perform(with: self.accumulator)
    }
}
