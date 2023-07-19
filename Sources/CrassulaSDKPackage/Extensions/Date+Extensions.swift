//
//  Date+Extensions.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 4/2/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import Foundation

extension Date {
    
    static func date(string: String, with format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        //formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        
        return formatter.date(from: string)
    }
    
    func string(with format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: ConfigManager.shared.langCode)
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func stringDate(_ style: DateFormatter.Style = .long) -> String {
        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: ConfigManager.shared.langCode)
        formatter.dateStyle = style
        formatter.timeStyle = .none
        
        return formatter.string(from: self)
    }
    
    func stringFormatted() -> String {
        return string(with: "yyyy-MM-dd'T'HH:mm:ssZ")
    }
    
    func monthInterval() -> (start: Date, end:Date) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: self)
        components.day = 1
        let startOfMonth = calendar.date(from: components)!

        var componentsEnd = DateComponents()
        componentsEnd.month = 1
        componentsEnd.day = -1
        let endOfMonth = calendar.date(byAdding: componentsEnd, to: startOfMonth)!
        
        return (startOfMonth, endOfMonth)
    }
    
    func monthString() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        let componentsToday = calendar.dateComponents([.year], from: Date())
        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: ConfigManager.shared.langCode)
        let month = formatter.standaloneMonthSymbols[(components.month ?? 1) - 1].capitalizingFirstLetter()
        if components.year == componentsToday.year {
            return month
        } else {
            formatter.dateFormat = "yyyy"
        }
        return "\(month), \(formatter.string(from: self))"
    }
    
    func dayValue() -> Date {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: comps) ?? Date()
    }
    
    func startOfMonth() -> Date {
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: self)
        comps.day = 1
        return Calendar.current.date(from: comps) ?? Date()
    }
    
    func endOfMonth() -> Date {
        var comps = DateComponents()
        comps.month = 1
        comps.day = -1
        return Calendar.current.date(byAdding: comps, to: startOfMonth()) ?? Date()
    }
    
    func startNextMonth() -> Date {
        var comps = DateComponents()
        comps.month = 1
        return Calendar.current.date(byAdding: comps, to: startOfMonth()) ?? Date()
    }
}

