//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by тигренок  on 9/18/15.
//  Copyright (c) 2015 Midori.s. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    
    
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return "\(symbol)"
                case .BinaryOperation(let symbol, _):
                    return "\(symbol)"
                    
                }
            }
            
        }

        
        
    }
    
    private var opStract =  [Op]()
    
    private var knownOps = [String: Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") {$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)

    }
    
    var program: AnyObject { // guaranteed to be a PropertyList
        get {
            
            return opStract.map { $0.description }
            // Same
//            var returnValue = [String]()
//            for op in opStract {
//                returnValue.append(op.description)
//            }
//            return returnValue
        }
        set {
            if let opSymbols = newValue as? [String] {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStract = newOpStack
            }
            
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remaningOps: [Op]){
        
        if !ops.isEmpty {
            var remaningOps = ops
            let op = remaningOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remaningOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remaningOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remaningOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remaningOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remaningOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1,operand2), op2Evaluation.remaningOps)
                    }
                }
                
            }
        }
        return (nil, ops)
    }
    
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStract)
        println("\(opStract) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStract.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]{
            opStract.append(operation)
        }
        return evaluate()
    }
    
}
