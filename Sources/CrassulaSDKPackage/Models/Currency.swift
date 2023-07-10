//
//  Currency.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 9/2/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import UIKit

class Currency: ValueLabel {
    var type: Int8 = 0
    
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(Int8.self, forKey: .type) ?? 0
        try super.init(from: decoder)
    }

    init(label: String, value: String, type: Int8) {
        super.init(label: label, value: value)
        self.type = type
    }
}
