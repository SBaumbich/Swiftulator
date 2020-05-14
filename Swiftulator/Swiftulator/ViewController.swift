//
//  ViewController.swift
//  Swiftulator
//
//  Created by Scott Baumbich on 5/13/20.
//  Copyright © 2020 Keasbey Nights. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var expressionTextField: UITextField!
    @IBOutlet weak var mainTextField: UITextField!
    
    var onScreenValue = 0.0
    var previousValue = 0.0
    var operatorValue = 0
    var isCalculating = true
    var isClear = true
    var isTrigonometry = false
    var expression = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTextField.text = ""
    }
//-----------------------------------------------------------------
    @IBAction func clearButton(_ sender: Any) {
        clear()
    }
//-----------------------------------------------------------------
    @IBAction func numberButtons(_ number: UIButton) {
        let numberPressed = number.tag
        
        if isCalculating == true {
            isCalculating = false
            mainTextField.text = String(numberPressed)
            
            if let oppValue = Operator(rawValue: operatorValue)?.description {
                expression = expression + oppValue
            }
            expression = expression + String(numberPressed)
            
        } else if let text = mainTextField.text {
            mainTextField.text = text + "\(numberPressed)"
            expression = expression + String(numberPressed)
        }
        
        if let resultText = mainTextField.text, let numberOnScreen = Double(resultText) {
            onScreenValue = numberOnScreen
        }
        print(expression)
    }
//-----------------------------------------------------------------
    @IBAction func decimalButton(_ sender: Any) {
        if let text = mainTextField.text {
            if text.contains("."){
                if Double(mainTextField.text!) != nil{
                    return //We have a valide number (Don't add another decimal)
                } else {
                    if text.contains("."){
                        return // Prevent enting "......."
                    } else {
                        print(mainTextField.text!)
                        mainTextField.text = text + "."
                        expression = expression + "."
                    }
                }
            } else if text == "+" || text == "-" || text == "x" || text == "÷" || text == "SIN" || text == "COS" || text == "TAN"{
                mainTextField.text = "."
                if let oppValue = Operator(rawValue: operatorValue)?.description {
                    expression = expression + oppValue
                }
                isCalculating = false
                expression = expression + "."
            } else {
                mainTextField.text = text + "."
                if let oppValue = Operator(rawValue: operatorValue)?.description {
                    expression = expression + oppValue
                }
                isCalculating = false
                expression = expression + "."
            }
        }
    }
//-----------------------------------------------------------------
    @IBAction func operatorButton(_ operation: UIButton) {
        let tag = operation.tag
        
        if (tag == 10 || tag == 11 || tag == 12 || tag == 13) && isTrigonometry == false {
            
            //Calculate multiple operators in one expression ( 5 + 3 - 8 x 37)
            if isClear == false && (Double(mainTextField.text!) != nil) {
                calculate()
            }
            
            operatorValue = tag
            isCalculating = true
            isClear = false
            
            //Prevent updating the previousValue with a bad string
            if let text = Double(mainTextField.text!) {
                previousValue = text
            }
            
            if tag == 10 {
                mainTextField.text = "+"
            } else if tag == 11{
                mainTextField.text = "-"
            } else if tag == 12 {
                mainTextField.text = "x"
            } else if tag == 13 {
                mainTextField.text = "÷"
            }
        }
    }
//-----------------------------------------------------------------
    @IBAction func trigonometry(_ sender: UIButton) {
        let tag = sender.tag
        onScreenValue = 0.0
        previousValue = 0.0
        isTrigonometry = true
        operatorValue = tag
        isCalculating = true
        isClear = false
        expression = ""
        expressionTextField.text = expression
        
        if tag == 14 {
            mainTextField.text = "SIN"
        } else if tag == 15{
            mainTextField.text = "COS"
        } else if tag == 16 {
            mainTextField.text = "TAN"
        }
    }
    
//-----------------------------------------------------------------
    @IBAction func equalButton(_ sender: Any) {
        calculate()
        isTrigonometry = false
    }
//-----------------------------------------------------------------
    @IBAction func negButton(_ sender: Any) {
        //TODO: - add the ability to swap between negative and positive numbers
    }
//-----------------------------------------------------------------
    
//MARK: - Helper Functions
    
    func calculate() {
        if operatorValue == 10 {
            mainTextField.text = String(previousValue + onScreenValue)
        } else if operatorValue == 11 {
            mainTextField.text = String(previousValue - onScreenValue)
        } else if operatorValue == 12 {
            mainTextField.text = String(previousValue * onScreenValue)
        } else if operatorValue == 13 {
            mainTextField.text = String(previousValue / onScreenValue)
        } else if operatorValue == 14 {
            mainTextField.text = String(sin(onScreenValue))
        } else if operatorValue == 15 {
            mainTextField.text = String(cos(onScreenValue))
        } else if operatorValue == 16 {
            mainTextField.text = String(tan(onScreenValue))
        }
        expressionTextField.text = expression
    }
//-----------------------------------------------------------------
    
    func clear() {
        mainTextField.text = ""
        expression = ""
        expressionTextField.text = expression
        onScreenValue = 0.0
        previousValue = 0.0
        operatorValue = 0
        isCalculating = true
        isClear = true
    }
//-----------------------------------------------------------------
    
    func printCurrentValues() {
        print("onScreenValue: \(onScreenValue)")
        print("previousValue: \(previousValue)")
        print("operatorValue: \(operatorValue)")
        print("isCalculating: \(isCalculating)")
        
    }
}

//-----------------------------------------------------------------
// Operator Button Tags

    enum Operator: Int {
        case addition = 10
        case subtraction = 11
        case multiplication = 12
        case division = 13
        case sin = 14
        case cos = 15
        case tan = 16
    }
//-----------------------------------------------------------------

extension Operator: CustomStringConvertible {
    var description: String {
        switch self {
        case .addition: return " + "
        case .subtraction: return " - "
        case .multiplication: return " x "
        case .division: return " ÷ "
        case .sin: return " SIN "
        case .cos: return " COS "
        case .tan: return " TAN "
        }
    }
}


//TODO: - Separate logic into different files / folders
