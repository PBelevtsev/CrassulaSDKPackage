//
//  File.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 8/13/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import Foundation

class CardInfo: Codable {
    
    var cvc: String
    var number: String
    var holder: String
    var expirationMonth: Int
    var expirationYear: Int
    
    enum CodingKeys: String, CodingKey {
        case cvc = "cvc"
        case number = "number"
        case holder = "holder"
        case expirationMonth = "expirationMonth"
        case expirationYear = "expirationYear"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cvc = try container.decodeIfPresent(String.self, forKey: .cvc) ?? ""
        self.number = try container.decodeIfPresent(String.self, forKey: .number) ?? ""
        self.holder = try container.decodeIfPresent(String.self, forKey: .holder) ?? ""
        self.expirationMonth = try container.decodeIfPresent(Int.self, forKey: .expirationMonth) ?? 0
        self.expirationYear = try container.decodeIfPresent(Int.self, forKey: .expirationYear) ?? 0
    }
}
