//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Tiyang Lou on 1/13/15.
//  Copyright (c) 2015 loutiyang. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
        
        var description: String
        {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
         }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["÷"] = Op.BinaryOperation("÷"){ $1 / $0 }
        knownOps["−"] = Op.BinaryOperation("−"){ $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["^2"] = Op.UnaryOperation("^2"){pow($0,2)}
        knownOps["+/-"] = Op.UnaryOperation("+/-"){-$0}
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["tan"] = Op.UnaryOperation("tan", tan)
        knownOps["%"] = Op.UnaryOperation("%"){$0/100}

    }
    
    private func evaluate(ops: [Op]) ->(result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearOperation(){
        opStack.removeAll()
    }
}
