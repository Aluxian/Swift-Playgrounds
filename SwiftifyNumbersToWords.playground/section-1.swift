// Playground - noun: a place where people can play

import Cocoa

// Word representations of numbers
let ones = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
let teens = ["", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
let tens = ["",  "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]
let powers = ["", "ten", "hundred", "thousand", "million", "billion", "trillion", "quadrillion", "quintillion",
    "sextillion", "septillion", "octillion", "nonillion", "decillion", "undecillion", "duodecillion", "tredecillion",
    "quattuordecillion", "quinquadecillion", "sedecillion", "septendecillion", "octodecillion", "novendecillion",
    "vigintillion", "unvigintillion", "duovigintillion", "tresvigintillion", "quattuorvigintillion", "quinquavigintillion",
    "sesvigintillion", "septemvigintillion", "octovigintillion", "novemvigintillion", "trigintillion", "untrigintillion",
    "duotrigintillion", "trestrigintillion", "quattuortrigintillion", "quinquatrigintillion", "sestrigintillion",
    "septentrigintillion", "octotrigintillion", "noventrigintillion", "quadragintillion"]

func convert(var digits: [Int]) -> String {
    var words = [String]()
    
    // Reverse the digits array
    digits = reverse(digits)
    
    // Wordify
    for (rank, digit) in enumerate(digits) {
        switch rank % 3 {
        case 0:
            if digits.count == 1 {
                words.append(ones[digit])
            } else if rank > 2 {
                if digits.count > rank + 1 && digits[rank + 1] > 0 || digits.count > rank + 2 && digits[rank + 2] > 0 {
                    words.append(powers[rank / 3 + 2] + ",")
                } else if digit != 0 {
                    words.append(ones[digit] + " " + powers[rank / 3 + 2] + ",")
                }
            }
            
        case 1:
            if digits[rank - 1] == 0 {
                if digit != 0 {
                    if digits.count > rank + 1 && digits[rank + 1] > 0 && rank == 1 {
                        words.append("and " + tens[digit])
                    } else {
                        words.append(tens[digit])
                    }
                }
            } else if digit == 1 {
                words.append(teens[digits[rank - 1]])
            } else if digit == 0 {
                if rank == 1 {
                    words.append("and " + ones[digits[rank - 1]])
                } else {
                    words.append(ones[digits[rank - 1]])
                }
            } else {
                words.append(tens[digit] + "-" + ones[digits[rank - 1]])
            }
            
        case 2:
            if digits.count == 1 {
                words.append(ones[digit])
            } else if digit != 0 {
                words.append(ones[digit] + " hundred")
            }
            
        default:
            break
        }
    }
    
    // Join words
    var result = " ".join(reverse(words))
    
    // Remove some commas
    if [Character](result).last? == "," {
        result = result.substringWithRange(Range<String.Index>(start: result.startIndex, end: advance(result.endIndex, -1)))
    }
    
    result = result.stringByReplacingOccurrencesOfString(", and", withString: " and", options: NSStringCompareOptions.LiteralSearch, range: nil)
    
    return result
}

///
/// Convert the given Double number into its english representation in words.
///
/// Maximum number: 10^123
/// Minimum number: -10^123
///
/// Maximum number of decimals: 123
///
///
func convert(num: Double) -> String {
    // Split the number into two parts: the one before the decimal point and the one after
    let numStringParts = NSString(format: "%f", abs(num)).componentsSeparatedByString(".") as [String]
    let leftString = numStringParts[0]
    let rightString = numStringParts[1]
    
    // Convert the strings into arrays of digits
    var leftDigits = [Character](leftString).map { String($0).toInt()! }
    var rightDigits = [Character](rightString).map { String($0).toInt()! }
    
    // Remove zeroes at the beginning of leftDigits, unless there's only one
    while leftDigits.first? == 0 && leftDigits.count > 1 {
        leftDigits.removeAtIndex(0)
    }
    
    // Remove zeroes at the end of rightDigits
    while rightDigits.last? == 0 {
        rightDigits.removeAtIndex(rightDigits.count - 1)
    }
    
    // Convert the digits into words
    let leftWords = convert(leftDigits)
    let rightWords = convert(rightDigits)
    
    // Wordify the minus sign for negative numbers
    let minus = num < 0 ? "minus " : ""
    
    // Wordify the decimal point for decimal numbers
    let point = rightWords.utf16Count > 0 ? " and " : ""
    
    // Wordify the decimal unit
    var unitDigits = [1]
    
    for digit in 0..<rightDigits.count {
        unitDigits.append(0)
    }
    
    var unit = convert(unitDigits) + "ths"

    if unitDigits.count > 1 {
        unit = unit.stringByReplacingOccurrencesOfString("one ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        unit = unit.stringByReplacingOccurrencesOfString(" ", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
        unit = " " + unit
    } else {
        unit = ""
    }
    
    // Concatenate and return
    return minus + leftWords + point + rightWords + unit
}




// Some quick conversions
convert(0)
convert(1)
convert(2)
convert(10)
convert(15.0645)
convert(40)
convert(59.5269)
convert(42)
convert(99)
convert(100)
convert(101)
convert(110)
convert(500)
convert(1_000)
convert(10_000)
convert(1_234)
convert(21_234)
convert(411_234)
convert(411)
convert(234)
convert(4_695_234)
convert(-1_000_000)
convert(1_000_000)
convert(50)


// TESTS: Please open the Assistant editor and look into the console
// Change this to true if you want to run the tests
let RUN_TESTS = false

if RUN_TESTS {
    // Test 1: Powers of ten
    println("\nTest 1: Powers of ten")
    for i in 0...123 {
        var digits = [1]
        
        for digit in 0..<i {
            digits.append(0)
        }
        
        println("10^\(i) -> \(convert(digits))")
    }

    // Test 2: Random integers
    println("\nTest 2: Random numbers")
    for i in 0..<100 {
        let num = Double(arc4random_uniform(UInt32(Float(INT_MAX) / Float(i * i + 1))))  * (arc4random_uniform(2) == 1 ? 1 : -1)
        println("\(Int(num)) -> \(convert(num))")
    }
    
    // Test 3: Random floating point numbers
    println("\nTest 3: Random floating point numbers")
    for i in 0..<100 {
        let num = Double(arc4random_uniform(UInt32(INT_MAX))) / 100000 * (arc4random_uniform(2) == 1 ? 1 : -1)
        println("\(num) -> \(convert(num))")
    }
}














