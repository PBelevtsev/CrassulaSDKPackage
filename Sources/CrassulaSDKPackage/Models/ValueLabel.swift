//
//  ValueLabel.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 02.04.2023.
//  Copyright © 2023 CratechOU. All rights reserved.
//

import Foundation

class ValueLabel: Decodable {
    var label: String
    var value: String
    
    enum CodingKeys: String, CodingKey {
        case label
        case value
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.label = try container.decodeIfPresent(String.self, forKey: .label) ?? ""
        self.value = try container.decodeIfPresent(String.self, forKey: .value) ?? ""
    }

    init(label: String, value: String) {
        self.label = label
        self.value = value
    }
}
