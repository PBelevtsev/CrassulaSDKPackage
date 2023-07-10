//
//  CardSettings.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 8/13/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import Foundation

class CardSettings: NSObject, Codable {
    
    var secure3d: Bool = false
    var onlinePayments: Bool = false
    var atmWithdrawal: Bool = false
    var contactlessPayment: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case secure3d = "secure3d"
        case onlinePayments = "onlinePayments"
        case atmWithdrawal = "atmWithdrawal"
        case contactlessPayment = "contactlessPayment"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.secure3d = try container.decodeIfPresent(Bool.self, forKey: .secure3d) ?? false
        self.onlinePayments = try container.decodeIfPresent(Bool.self, forKey: .onlinePayments) ?? false
        self.atmWithdrawal = try container.decodeIfPresent(Bool.self, forKey: .atmWithdrawal) ?? false
        self.contactlessPayment = try container.decodeIfPresent(Bool.self, forKey: .contactlessPayment) ?? false
    }
    
    override init() {
        super.init()
        
    }
    
}
