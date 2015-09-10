//
//  ViewController.swift
//  Calculator
//
//  Created by Tiyang Lou on 1/13/15.
//  Copyright (c) 2015 loutiyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            if !((display.text!.rangeOfString(".") != nil)&&(digit == ".")){
                if !(display.text!.rangeOfString("π") != nil){
                    display.text = display.text! + digit
                }
            }
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
            
        }
    }

    @IBAction func clear() {
        brain.clearOperation()
        displayValue = 0
        enter()
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber{
            if count(display.text!) == 1 {
                displayValue = 0
                enter()
            }else {
                display.text! = dropLast(display.text!)
            }
        }
    }
   
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double {
        get {
            if display.text!.rangeOfString("π") != nil  {
                if display.text == "π" {
                    return M_PI as Double
                }else {
                    var removePiFromString = display.text?.stringByReplacingOccurrencesOfString("π", withString: "")
                    return NSNumberFormatter().numberFromString(removePiFromString!)!.doubleValue * M_PI
                }
                
            } else {
                return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            }
        }
        set {
            display.text = "\(newValue)"
        }
    }
}

