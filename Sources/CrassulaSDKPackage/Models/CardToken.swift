//
//  CardToken.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 31.10.2019.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import UIKit

class CardToken: Codable {
    var id: String
    var expiresAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case expiresAt = "expiresAt"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.expiresAt = (try container.decodeIfPresent(String.self, forKey: .expiresAt) ?? "").dateValue
    }

}
