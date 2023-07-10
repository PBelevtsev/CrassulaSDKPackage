//
//  CardPin.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 26.09.2020.
//  Copyright © 2020 CratechOU. All rights reserved.
//

import Foundation

class CardPin: Codable {
    
    var pin: String
    
    enum CodingKeys: String, CodingKey {
        case pin = "pin"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pin = try container.decodeIfPresent(String.self, forKey: .pin) ?? ""
    }
}
