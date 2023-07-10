//
//  Balance.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 3/30/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import UIKit
import CoreData

class Balance: NSObject, Codable {
    var currency: String = ""
    var current: Double = 0.0
    var reserved: Double = 0.0
    var available: Double = 0.0
    var isEmpty = false
    
    enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case current = "current"
        case reserved = "reserved"
        case available = "available"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.current = Double(try container.decodeIfPresent(String.self, forKey: .current) ?? "0.0") ?? 0.0
        self.reserved = Double(try container.decodeIfPresent(String.self, forKey: .reserved) ?? "0.0") ?? 0.0
        self.available = Double(try container.decodeIfPresent(String.self, forKey: .available) ?? "0.0") ?? 0.0
    }
    
    init(currency: String, current: Double, reserved: Double, available: Double) {
        self.currency = currency
        self.current = current
        self.reserved = reserved
        self.available = available
    }
    
    init(currency: String) {
        super.init()
        
        self.currency = currency
        self.current = 0.0
        self.reserved = 0.0
        self.available = 0.0
        self.isEmpty = true
    }
    
}
