//
//  CardLimit.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 8/14/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import Foundation

class CardLimit: Codable {
    
    var id: String
    var period: Int
    var currency: String
    var amount: Double
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case period = "period"
        case currency = "currency"
        case amount = "amount"
        case createdAt = "created_at"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.period = try container.decodeIfPresent(Int.self, forKey: .period) ?? 0
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.amount = try container.decodeIfPresent(Double.self, forKey: .amount) ?? 0.0
        self.createdAt = (try container.decodeIfPresent(String.self, forKey: .createdAt) ?? "").dateValue ?? Date()
    }
}
