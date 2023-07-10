//
//  TfaMethod.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 6/7/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import Foundation

class TfaMethod: NSObject, Codable, NSCoding {
    var id: String
    var type: Int
    var settings: [String : String]
    var isDefault: Bool
    
//    "id": "34313f63-7c66-4ac7-9a8f-0d144a316aca",
//    "type": 0,
//    "settings": {
//    "phoneNumber": "380504738767"
//    },
//    "isDefault": false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case settings = "settings"
        case isDefault = "isDefault"
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.type = try container.decodeIfPresent(Int.self, forKey: .type) ?? 0
        self.settings = try container.decodeIfPresent([String : String].self, forKey: .settings) ?? [:]
        self.isDefault = try container.decodeIfPresent(Bool.self, forKey: .isDefault) ?? false
        
    }
    
    init(id: String, type: Int, settings: [String : String], isDefault: Bool) {
        self.id = id
        self.type = type
        self.settings = settings
        self.isDefault = isDefault
    }
    
    convenience init(phoneNumber: String) {
        self.init(id: "", type: 0, settings: ["phoneNumber" : phoneNumber], isDefault: true)
    }
    
    convenience init(type: Int) {
        self.init(id: "", type: type, settings: [:], isDefault: false)
    }
    
    convenience init(token: String) {
        self.init(id: "", type: 1, settings: ["token" : token], isDefault: true)
    }
    
    func isPhoneNumber() -> Bool {
        return (settings["phoneNumber"] != nil)
    }
    
    func isToken() -> Bool {
        return (settings["token"] != nil)
    }
    
    var isExist: Bool {
        return id.count > 0
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: CodingKeys.self.id.rawValue)
        aCoder.encode(type, forKey: CodingKeys.self.type.rawValue)
        aCoder.encode(settings, forKey: CodingKeys.self.settings.rawValue)
        aCoder.encode(isDefault, forKey: CodingKeys.self.isDefault.rawValue)
    }
    
    required public init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: CodingKeys.self.id.rawValue) as! String
        type = aDecoder.decodeInteger(forKey: CodingKeys.self.type.rawValue)
        settings = aDecoder.decodeObject(forKey: CodingKeys.self.settings.rawValue) as! [String : String]
        isDefault = aDecoder.decodeBool(forKey: CodingKeys.self.isDefault.rawValue)
    }
    
}

