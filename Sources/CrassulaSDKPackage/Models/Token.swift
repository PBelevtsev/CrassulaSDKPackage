//
//  Token.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 3/30/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import UIKit

class Token: NSObject, Codable, NSCoding {
    var clientId: String?
    var token: String?
    var refreshToken: String?
    var payload: Payload?
    
    var expireDate = Date()
    var isExpired: Bool {
        let interval = expireDate.timeIntervalSince(Date())
        //print("isExpired \(interval)")
        return (interval < 60 * 1)
    }
    
    enum CodingKeys: String, CodingKey {
        case clientId = "clientId"
        case token = "token"
        case refreshToken = "refresh_token"
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clientId = try container.decodeIfPresent(String.self, forKey: .clientId)
        self.token = try container.decodeIfPresent(String.self, forKey: .token) ?? ""
        self.refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        
        if let base64Encoded = token {
            let payloadJson = decode(jwtToken: base64Encoded)
            
            let jsonData = try? JSONSerialization.data(withJSONObject:payloadJson)
            
            if let data = jsonData  {
                do {
                    let decoder = JSONDecoder()
                    self.payload = try decoder.decode(Payload.self, from: data)
                } catch _ {
                    
                }
            }
            
            if let payload = self.payload {
                let delta = Date().timeIntervalSince1970 - Double(payload.iat)
                
                self.expireDate = Date.init(timeIntervalSince1970: TimeInterval(Double(payload.exp) + delta))                
            }
        }
    
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(token, forKey:"token")
        aCoder.encode(refreshToken, forKey:"refreshToken")
        aCoder.encode(expireDate, forKey:"expireDate")
    }
    
    required public init(coder aDecoder: NSCoder) {
        token = aDecoder.decodeObject(forKey: "token") as? String
        refreshToken = aDecoder.decodeObject(forKey: "refreshToken") as? String
        expireDate = aDecoder.decodeObject(forKey: "expireDate") as! Date
    }
    
    func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        if (segments.count > 1) {
            return decodeJWTPart(segments[1]) ?? [:]
        } else {
            return [:]
        }
    }
    
    func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
            let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
        }
        
        return payload
    }
    
    func defaultTfaMethod() -> TfaMethod? {
        return payload?.defaultTfaMethod()
    }
    
    func tfaRequired() -> Bool {
        if let payload = self.payload {
            return payload.tfaRequired && !payload.tfaVerified
        } else {
            return false
        }
    }
}
