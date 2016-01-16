// Playground - noun: a place where people can play

import Cocoa

/// Common credit card issuers and their corresponding regular expression for validation.
let issuers = [
    "American Express": "^3[47][0-9]{13}$",
    "China UnionPay": "^62[0-5]\\d{13,16}$",
    "Diner's Club": "^3(?:0[0-5]|[68][0-9])[0-9]{11}$",
    "Discover": "^6(?:011|5[0-9]{2})[0-9]{12}$",
    "JCB": "^(?:2131|1800|35\\d{3})\\d{11}$",
    "Maestro": "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$",
    "MasterCard": "^5[1-5][0-9]{14}$",
    "Visa": "^4[0-9]{12}(?:[0-9]{3})?$"
]

/// Wrapper around NSRegularExpression that providers various regex helpers.
class Regex {
    
    let pattern: String
    let expression: NSRegularExpression
    
    init(_ pattern: String) {
        self.pattern = pattern
        self.expression = NSRegularExpression(pattern: pattern, options: nil, error: nil)
    }
    
    func test(input: String) -> Bool {
        return expression.matchesInString(input, options: nil, range: NSMakeRange(0, countElements(input))).count > 0
    }
    
    func replaceMatchesIn(input: String, with: String) -> String {
        return expression.stringByReplacingMatchesInString(input, options: nil, range: NSMakeRange(0, countElements(input)), withTemplate: with)
    }
    
}

/// Parse and get information about a credit card number.
class CreditCard {
    
    /// The credit card number, re-formatted and stripped of invalid characters.
    let number: String
    
    // Init
    init(_ cc: String) {
        // Remove all the non-digit characters
        number = Regex("\\D+").replaceMatchesIn(cc, with: "")
    }
    
    /// Returns true if the credit card number is valid, false otherwise.
    func isValid() -> Bool {
        // First do a simple and fast check on length.
        // Then make sure the number is formatted according to one of the issuers.
        // Lastly, use Luhn's algorithm for one more check.
        return validateWithCount() && validateWithRegex() && validateWithLuhn()
    }
    
    /// Returns the name of the issuer company.
    func company() -> String? {
        for (issuer, pattern) in issuers {
            if Regex(pattern).test(number) {
                return issuer
            }
        }
        
        return nil
    }
    
    /// Tests if the credit card number has an appropriate length.
    private func validateWithCount() -> Bool {
        return number.utf16Count >= 13 && number.utf16Count <= 19
    }
    
    /// Tests if the credit card number is correctly formatted using a regular expression.
    private func validateWithRegex() -> Bool {
        // Instead of checking all the regex patterns, merge them into only one. This should make things faster.
        return Regex("(?:" + "|".join(issuers.values) + ")").test(number)
    }
    
    /// Tests if the credit card number is valid according to the Luhn algorithm.
    private func validateWithLuhn() -> Bool {
        var sum = 0
        
        for (i, digit) in enumerate(reverse(number)) {
            if i % 2 == 0 {
                sum += String(digit).toInt()!
            } else {
                let num = 2 * String(digit).toInt()!
                sum += num % 10 + num / 10
            }
        }
        
        return sum % 10 == 0
    }
    
}



CreditCard("4111 1111 1111 1111").isValid()
CreditCard("4111 1111 1111 1111").company()

CreditCard("5555 5555 5555 4444").isValid()
CreditCard("5555 5555 5555 4444").company()

CreditCard("3714 496353 98431").isValid()
CreditCard("3714 496353 98431").company()

CreditCard("6011 1111 1111 1117").isValid()
CreditCard("6011 1111 1111 1117").company()

CreditCard("3530 1113 3330 0000").isValid()
CreditCard("3530 1113 3330 0000").company()

CreditCard("4000 0000 0000 0002").isValid()
CreditCard("4000 0000 0000 0002").company()

CreditCard("4026 0000 0000 0002").isValid()
CreditCard("4026 0000 0000 0002").company()

CreditCard("5018 0000 0009").isValid()
CreditCard("5018 0000 0009").company()

CreditCard("5100 0000 0000 0008").isValid()
CreditCard("5100 0000 0000 0008").company()

CreditCard("6011 0000 0000 0004").isValid()
CreditCard("6011 0000 0000 0004").company()

CreditCard("0824982390480248239408923408").isValid()
CreditCard("0824982390480248239408923408").company()











