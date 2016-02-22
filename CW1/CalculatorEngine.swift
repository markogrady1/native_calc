//
//  CalculatorEngine.swift
//  CW1
//
//  Created by Mark O'Grady on 06/02/2016.
//  Copyright (c) 2016 Mark O'Grady. All rights reserved.
//

import Foundation
import UIKit

class CalculatorEngine {
    
    var degrees = true
    var opStack = Array<Double>()
    let pi = M_PI
    
    func updateStackWithValue(value:Double) {
        self.opStack.append(value)
        print(self.opStack, terminator: "")
    }
    
    /**
     * function reponsible for assigning the correct calculation to the operand
     * each function call uses the shorthand notation of using $0 or &1 
     * to represent the first and second arguments respectivly.
     * this shorthand represents a closure function that was passed as an argument
     */
    func operate(operation: String) -> Double {
        switch operation {
            case "x²": return calculate { pow($0, 2.0) }
            case "x³": return calculate { pow($0, 3.0)}
            case "¹/x": return calculate { 1 / $0 }
            case "√": return calculate { sqrt($0) }
            case "+": return calculate { $0 + $1 }
            case "÷": return calculate { $1 / $0 }
            case "×": return calculate { $0 * $1 }
            case "−": return calculate { $1 - $0 }
            case "log₁₀": return calculate { log10($0) }
            case "ln": return calculate { log($0) }
            case "log₂": return calculate { log2($0) }
            case "10ˣ": return calculate { pow(10, $0) }
            case "asin": return degrees ? calculate { asin($0 ) * 180 / M_PI } : calculate { asin($0) }
            case "acos": return degrees ? calculate { acos($0) * 180 / M_PI } : calculate { acos($0) }
            case "atan": return degrees ? calculate { atan($0) * 180 / M_PI } : calculate { atan($0) }
            case "sin": return degrees ? calculate { sin($0 * M_PI / 180) } : calculate { sin($0) }
            case "cos": return degrees ? calculate { cos($0 * M_PI / 180) } : calculate { cos($0) }
            case "tan": return degrees ? calculate { tan($0 * M_PI / 180) } : calculate { tan($0) }
            default:
                break
        }
        return 0.0
    }
    
    /**
     * function reponsible for calculating and obtaining the given arguments
     * this function takes another function as an argument
     * the closure function takes two arguments and returns a double
     * it then takes the last two values off the stack and uses them for the calculation
     * this new value is then placed on the stack
     */
    func calculate(calculation: (Double, Double) -> Double) -> Double{
        if self.opStack.count >= 2 {
            let tmp = calculation(self.opStack.removeLast(), self.opStack.removeLast())
            self.opStack.append(tmp)
            return tmp
        }
        return 0.0
    }
    
    /**
     * function reponsible for calculating and obtaining the given arguments
     * this function takes another function as an argument
     * the closure function takes one single argument (Double) and returns a double
     * it then takes the last two values off the stack and uses them for the calculation
     * this new value is then placed on the stack
     */
    func calculate(calculate: (Double) -> Double) -> Double {
        if self.opStack.count >= 1 {
            return calculate(self.opStack.removeLast())
        }
        return 0.0
    }
    /**
     * function responsible for formating the PI value
     * the function uses the NSString function to achieve this and returns a value with 8 decimal places
     */
    func piFormat() -> String {
        return NSString(format: "%.8f", pi) as String
    }
}
