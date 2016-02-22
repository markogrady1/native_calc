//
//  ViewController.swift
//  CW1
//
//  Created by Mark O'Grady on 04/02/2016.
//  Copyright (c) 2016 Mark O'Grady. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    /**these variables have been created as a reference for the 2nd button*/
    @IBOutlet weak var radianButton: UIButton!
    @IBOutlet weak var tanButton: UIButton!
    @IBOutlet weak var sinButton: UIButton!
    @IBOutlet weak var cosButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var powButton: UIButton!
    @IBOutlet weak var divByButton: UIButton!
    @IBOutlet weak var labelDisplay: UILabel!
    @IBOutlet weak var initialTapeDisplay: UILabel!
    var count = 1
    var status = 0
    var calcEngine: CalculatorEngine?
    var currentlyTypingNumber = false
    var decimalSelected = false
    
    /**
     * function responsible for adding a digit to the main output label
     * it kicks in when a digit is pressed
     */
    @IBAction func addDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "0" && labelDisplay.text! == "0" {
            //do nothing
        } else {
            if currentlyTypingNumber {
                labelDisplay.text = labelDisplay.text! + digit
            } else {
                labelDisplay.text = digit
                cancelButton.setTitle("C", forState: UIControlState.Normal)
                currentlyTypingNumber = true
            }
        }
    }

    /**
     * function responsible for sending the current display value to calcEngine class
     * it also writes values to NSUserDefaults and appends text to secondary display
     */
    @IBAction func enter() {
        currentlyTypingNumber = false
        decimalSelected = false
        self.calcEngine!.updateStackWithValue(displayValue)
        appendDisplayTape()
        //write the current values to NSUserDefaults
        self.writeToNSUserDefaults(labelDisplay.text!, "mainDisplayLabel")
        self.writeToNSUserDefaults(initialTapeDisplay.text!, "secondaryDisplayLabel")


    }
    
    /**
     * function responsible for toggling the app status between radians and degrees
     * it is triggered when the rad/deg button is clicked
     */
    @IBAction func calcStatus(sender: UIButton) {
        if ++status % 2 == 0 {
            statusLabel.text = " ᴰ"
            radianButton.setTitle("rad", forState:  UIControlState.Normal)
            self.calcEngine?.degrees = true
        } else {
            statusLabel.text = " ᴿ"
            radianButton.setTitle("deg", forState:  UIControlState.Normal)
            self.calcEngine?.degrees = false
        }
    }
    
    /**
     * function responsible for clearing both main and secondary displays
     * it will also remove all values from the stack if the mode is AC
     */
    @IBAction func clearDisplay(sender: UIButton) {
        let clr = sender.currentTitle
        if clr == "C" {
            currentlyTypingNumber = false
            labelDisplay.text = "0"
            cancelButton.setTitle("AC", forState: UIControlState.Normal)
        } else {
            currentlyTypingNumber = false
            self.calcEngine!.opStack.removeAll()
            labelDisplay.text = "0"
            enter()
            initialTapeDisplay.text = " "
            self.writeToNSUserDefaults("", "mainDisplayLabel")
            self.writeToNSUserDefaults("", "secondaryDisplayLabel")
        }
    }
    
    /**
     * function responsible for writing to NSUserDefaults 
     * the values will be taken from the main and the secondary displays
     */
    func writeToNSUserDefaults(value: String, _  key:String) {
        let mainLblDefaults = NSUserDefaults.standardUserDefaults()
        mainLblDefaults.setObject(value, forKey: key)
    }
    
    /**
     * function responsible for reading from NSUserDefaults
     * the values will be writen into the main and the secondary displays
     */
    func readFromNSUserDefaults(key: String) -> String {
        let secondaryLblDefaults = NSUserDefaults.standardUserDefaults()
        if let secondaryLabel = secondaryLblDefaults.stringForKey(key) {
           return secondaryLabel
        }
        return ""
    }
    
    /**
     * function responsible for placing the decimal in the main display
     * it will also check whether the decimal already exists
     */
    @IBAction func decimalSelected(sender: AnyObject) {
        let text = labelDisplay.text!
        let sections = text.componentsSeparatedByString(".")
        if sections.count != 2 {
            currentlyTypingNumber = true
            if decimalSelected == false {
                labelDisplay.text = labelDisplay.text! + "."
                decimalSelected = true
            }
        }
    }
    
    /**
     * function responsible for placing the PI value into the main display
     * it obtains the foratted value from the calcEngine class
     */
    @IBAction func piValue(sender: UIButton) {
        currentlyTypingNumber = true
        if labelDisplay.text != "0" {
            enter()
            labelDisplay.text = self.calcEngine?.piFormat()
            enter()
        } else {
            labelDisplay.text = self.calcEngine?.piFormat()
            enter()
        }
    }
    
    /**
     * function responsible for toggling between the different 2nd button values
     * the values of the cos, sin and tan buttons will be changed accordingly
     */
    @IBAction func secondSetOfOperands(sender: UIButton) {
        if ++count % 2 == 0 {
            cosButton.setTitle("acos", forState: UIControlState.Normal)
            sinButton.setTitle("asin", forState: UIControlState.Normal)
            tanButton.setTitle("atan", forState: UIControlState.Normal)
            logButton.setTitle("log₂", forState: UIControlState.Normal)
            powButton.setTitle("10ˣ", forState: UIControlState.Normal)
            divByButton.setTitle("x³", forState: UIControlState.Normal)

        } else {
            cosButton.setTitle("cos", forState: UIControlState.Normal)
            sinButton.setTitle("sin", forState: UIControlState.Normal)
            tanButton.setTitle("tan", forState: UIControlState.Normal)
            logButton.setTitle("log₁₀", forState: UIControlState.Normal)
            powButton.setTitle("x²", forState: UIControlState.Normal)
            divByButton.setTitle("¹/x", forState: UIControlState.Normal)


        }
    }
    
    /**
     * function responsible sending a given operand to the calcEngine class
     * it will also ensure the given operand is appended to the secondary display string
     */
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if currentlyTypingNumber {
            enter()
        }
        self.displayValue = self.calcEngine!.operate(operation)
        self.appendOperandToDisplayTape(operation + " = " + labelDisplay.text! + " ⏎")
    }
    
    /**
     * function responsible for toggling between negative and positive values in the main display
     * it will use the abs( ) function to ensure the correct value is provided
     */
    @IBAction func toggleNegativePositive() {
        let value = displayValue
        if value < 0 {
            displayValue = abs(value)
        } else {
            displayValue = value * -1
        }
    }
    
    /**
     * function responsible for getting and setting the value from the main display
     * it will ensure the value is cast to a Doube from a string when returning the value
     * it will also ensure the 'Error' string is displayed and correctly parsed when an error occurs
     * the setter section also checks whether the decimal place is needed in the display
     */
    var displayValue: Double {
        get{
            let tmpVal = labelDisplay.text == "Error" ? 0.0 : NSNumberFormatter().numberFromString(labelDisplay.text!)!.doubleValue
            return tmpVal
        }
        set {
            
//            labelDisplay.text = "\(newValue)"
            var tmpVal = "\(newValue)" == "nan" ? "Error" : "\(newValue)"
            tmpVal = "\(newValue)" == "inf" ? "Error" : "\(tmpVal)"
            if tmpVal.rangeOfString(".") != nil {
                 var tmpArr = tmpVal.componentsSeparatedByString(".")
            labelDisplay.text = tmpArr[1] == "0" ? tmpArr[0] : tmpVal

            } else {
                labelDisplay.text = tmpVal
            }
           //                        labelDisplay.text = tmpVal

        }
    }
    
    /**
     * function responsible for appending the given operands to the secondary display
     * it will also ensure the operands are only displayed once in a row
     * it does this by checking for operand duplicates
     */
    func appendOperandToDisplayTape(value: String) {
        var sections = initialTapeDisplay.text!.componentsSeparatedByString("⏎")
        var duplicate = false
        if(sections[sections.count-1] == " + " || sections[sections.count-1] == " ÷ " || sections[sections.count-1] == " × " || sections[sections.count-1] == " − ") {
            duplicate = true
        }
        if initialTapeDisplay.text != " " {
            if !duplicate {
                initialTapeDisplay.text = initialTapeDisplay.text! + value + " "
                duplicate = false
            }
        }
    }
    
    /**
     * function responsible for appending the last value in the stack to the secondary display
     * Note: the secondary display is the small tape display on the main view
     */
    func appendDisplayTape() {
        initialTapeDisplay.text = initialTapeDisplay.text!  + "\(self.calcEngine!.opStack[self.calcEngine!.opStack.count-1] ) ⏎ "
    }
    
    /**
     * function responsible for preparing the app for a change of view
     * it will pass the secondary string to the tapeViewController
     * it will also call the writeToNSUserDefault function to
     * store the main and secondary display values, so the data is not lost
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tapeViewController:TapeViewController = segue.destinationViewController as! TapeViewController
        //write both label values to NSUserDefaults
        self.writeToNSUserDefaults(labelDisplay.text!, "mainDisplayLabel")
        self.writeToNSUserDefaults(initialTapeDisplay.text!, "secondaryDisplayLabel")
        tapeViewController.tapeStr = initialTapeDisplay.text!
    }
    
    /**
     * function responsible for calling the readFromNSUserDefaults when app is loaded
     * this data will be loaded into labels.
     * this is so no data will be lost when app is shut down
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //get main display values from NSUserDefaults
        let tmpVal = readFromNSUserDefaults("mainDisplayLabel")
        if tmpVal != "" {
            labelDisplay.text = tmpVal
        }
        //get secondary display values from NSUserDefaults
        let secondaryTmpVal = readFromNSUserDefaults("secondaryDisplayLabel")
        if secondaryTmpVal != "" {
            initialTapeDisplay.text = secondaryTmpVal
        }
        self.calcEngine = CalculatorEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

