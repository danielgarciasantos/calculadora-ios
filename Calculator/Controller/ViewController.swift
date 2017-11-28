//
//  ViewController.swift
//  Calculator
//
//  Created by Rafagan Abreu on 13/11/17.
//  Copyright © 2017 CINQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var vigularButton: UIButton!
    var manager = CalculatorManager()
    var userIsTyping: Bool = false
    @IBOutlet weak var buttonAC: UIButton!
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func virgulaButton(_ sender: UIButton) {
    }
    
    @IBAction func touchClear(_ sender: UIButton) {
        let textButton = sender.currentTitle
        userIsTyping = false
        display.text = "0"
        if textButton == "AC"{
            manager.clear()
        }
        self.buttonAC.setTitle("AC", for: .normal)
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if self.userIsTyping {
            let textDisplay = display.text ?? ""
            display.text = textDisplay + digit
        } else {
            self.buttonAC.setTitle("C", for: .normal)
            display.text = digit
            userIsTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsTyping {
            userIsTyping = false
            self.manager.setOperand(displayValue)
        }
        if let mathSymbol = sender.currentTitle{
            self.manager.performOperation(mathSymbol)
        }

        displayValue = self.manager.result
      
        }

}
