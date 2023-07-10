//
//  Payload.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 6/7/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import Foundation

class Payload: Codable {
    var iat: Int
    var exp: Int
    var roles: [String]
    var username: String
    var currentCountryCode: String
    var tfaRequired: Bool
    var tfaVerified: Bool
    var tfaMethods: [TfaMethod]
    
    enum CodingKeys: String, CodingKey {
        case iat = "iat"
        case exp = "exp"
        case roles = "roles"
        case username = "username"
        case currentCountryCode = "currentCountryCode"
        case tfaRequired = "tfaRequired"
        case tfaVerified = "tfaVerified"
        case tfaMethods = "tfaMethods"
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.iat = try container.decodeIfPresent(Int.self, forKey: .iat) ?? 0
        self.exp = try container.decodeIfPresent(Int.self, forKey: .exp) ?? 0
        self.roles = try container.decodeIfPresent([String].self, forKey: .roles) ?? []
        self.username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        self.currentCountryCode = try container.decodeIfPresent(String.self, forKey: .currentCountryCode) ?? ""
        self.tfaRequired = try container.decodeIfPresent(Bool.self, forKey: .tfaRequired) ?? false
        self.tfaVerified = try container.decodeIfPresent(Bool.self, forKey: .tfaVerified) ?? false
        self.tfaMethods = try container.decodeIfPresent([TfaMethod].self, forKey: .tfaMethods) ?? []
    }
    
    func defaultTfaMethod() -> TfaMethod? {
        return tfaMethods.filter({ (tfaMethod) -> Bool in
            return tfaMethod.isDefault
        }).first
    }
    
}


