//
//  ViewController.swift
//  Calculator
//
//  Created by тигренок  on 8/31/15.
//  Copyright (c) 2015 Midori.s. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddelTypingANUmber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddelTypingANUmber {
            
        display.text = display.text! + digit
        println("Digit = \(digit)")
        } else {
            display.text = digit
            userIsInTheMiddelTypingANUmber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddelTypingANUmber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let resoult = brain.performOperation(operation) {
                displayValue = resoult
            } else {
                displayValue = 0
            }
        }
    }
    
    
    
    @IBAction func enter() {
        userIsInTheMiddelTypingANUmber = false
        if let resoult = brain.pushOperand(displayValue) {
            displayValue = resoult
        } else {
            displayValue = 0
        }

    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue

        } set {
            display.text = "\(newValue)"
            userIsInTheMiddelTypingANUmber = false
        }
    }

}

