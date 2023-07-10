//
//  String+Extensions.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 3/16/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isNumeric: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    
    var isEmailAddress: Bool {
        
        var returnValue = true
        let emailRegEx = "^(?=.{1,254}$)(?=.{1,64}@)[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    var dateValue: Date? {
        //2019-03-31T00:00:09+02:00
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return formatter.date(from: self)
    }
    
    var dateGMTValue: Date? {
        //2019-03-31T00:00:09+02:00
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var date = formatter.date(from: self)
        if let dateValue = date {
            let timeZone = NSTimeZone.default
            let interval = -timeZone.secondsFromGMT(for: dateValue)
            date = dateValue.addingTimeInterval(Double(interval))
        }
        return date
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func symbolForCurrencyCode() -> String {
        let result = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first { ($0.currencyCode == self) && ($0.currencySymbol != self)  }
        return result?.currencySymbol ?? self
    }
    
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func lowercasingFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    mutating func lowercaseFirstLetter() {
        self = self.lowercasingFirstLetter()
    }
    
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
              let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
              !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
    
    func validateCreditCardFormat() -> (type: PaymentCardType, valid: Bool) {
        // Get only numbers from the input string
        let input = self
        let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        var type: PaymentCardType = .Unknown
        var formatted = ""
        var valid = false
        
        // detect card type
        for card in PaymentCardType.allCards {
            if (numberOnly.matchesRegex(card.regex)) {
                type = card
                break
            }
        }
        
        // check validity
        valid = luhnCheck(numberOnly)
        
        // format
        var formatted4 = ""
        for character in numberOnly {
            if formatted4.count == 4 {
                formatted += formatted4 + " "
                formatted4 = ""
            }
            formatted4.append(character)
        }
        
        formatted += formatted4 // the rest
        
        // return the tuple
        return (type, valid)
    }
    
    
    func matchesRegex(_ regex: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = self as NSString
            let match = regex.firstMatch(in: self, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }
    
    func luhnCheck(_ number: String) -> Bool {
        var sum = 0
        
        //        let digitStrings = number.characters.reverse().map { String($0) }
        let reversed = String(number.reversed())
        
        for (index, symbol) in reversed.enumerated() { //digitStrings.enumerate() {
            let tuple = String(symbol)
            guard let digit = Int(tuple) else { return false }
            let odd = index % 2 == 1
            
            switch (odd, digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        
        return sum % 10 == 0
    }
    
    func validateCardExpiryDate() -> Bool {
        return self.count == 5
    }
    
    func decodeUrl() -> String {
        var result = replacingOccurrences(of: "&amp;", with: "&")
        result = result.removingPercentEncoding ?? ""
        return result
    }
    
    func sizeWith(font: UIFont, maxSize: CGSize) -> CGSize {
        return (self as NSString).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).size
    }
    
    var digitsOnly: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
