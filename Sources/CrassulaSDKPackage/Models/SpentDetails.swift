//
//  SpentDetails.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 8/14/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import Foundation

class SpentDetails: Codable {
    
    var period: Int
    var currency: String
    var spentAmount: Double
    var holdingAmount: Double
    var totalAmount: Double
    
    enum CodingKeys: String, CodingKey {
        case period = "period"
        case currency = "currency"
        case spentAmount = "spentAmount"
        case holdingAmount = "holdingAmount"
        case totalAmount = "totalAmount"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.period = try container.decodeIfPresent(Int.self, forKey: .period) ?? 0
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.spentAmount = Double(try container.decodeIfPresent(String.self, forKey: .spentAmount) ?? "") ?? 0.0
        self.holdingAmount = Double(try container.decodeIfPresent(String.self, forKey: .holdingAmount) ?? "") ?? 0.0
        self.totalAmount = Double(try container.decodeIfPresent(String.self, forKey: .totalAmount) ?? "") ?? 0.0
    }
}
