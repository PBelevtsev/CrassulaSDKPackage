//
//  TransferType.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 6/27/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import UIKit

public enum TransferTypeEnum: Int8 {
    case undefined
    case internalTransfer
    case sepaTransfer
    case swiftTransfer
    case selfTransfer
    case localTransfer
    case localCustomTransfer
    case cryptoTransfer
    case cardTransfer
    case manualTransfer
    case cryptoManualTransfer
    case cardTopUpTransfer
    case dynamicTransfer
    case dynamicLocalTransfer
    
    init(type: String?) {
        if let type = type {
            if type == "internal" {
                self = .internalTransfer
            } else if type == "sepa" {
                self = .sepaTransfer
            } else if type == "swift" {
                self = .swiftTransfer
            } else if type == "self" {
                self = .selfTransfer
            } else if (type == "local" || type == "local_faster_payments") {
                self = .localTransfer
            } else if type == "crypto" {
                self = .cryptoTransfer
            } else if type == "crypto_manual" {
                self = .cryptoManualTransfer
            } else if type == "card_top_up" {
                self = .cardTopUpTransfer
            } else if type == "dynamic" {
                self = .dynamicTransfer
            } else if type == "dynamic_local" {
                self = .dynamicLocalTransfer
            } else {
                self = .undefined
            }
        } else {
            self = .undefined
        }
    }
    
    var type: String {
        switch self {
        case .internalTransfer:
            return "internal"
        case .sepaTransfer:
            return "sepa"
        case .swiftTransfer:
            return "swift"
        case .selfTransfer:
            return "self"
        case .localTransfer, .localCustomTransfer:
            return "local"
        case .cryptoTransfer:
            return "crypto"
        case .cardTransfer:
            return "card"
        case .manualTransfer:
            return "manual"
        case .cryptoManualTransfer:
            return "crypto_manual"
        case .cardTopUpTransfer:
            return "cardTopUp"
        case .dynamicTransfer:
            return "dynamic"
        case .dynamicLocalTransfer:
            return "dynamic_local"
        case .undefined:
            return ""
        }
    }
    
    var isLocal: Bool {
        return ((self == .localTransfer) || (self == .localCustomTransfer))
    }
    
    var isCrypto: Bool {
        return ((self == .cryptoTransfer) || (self == .cryptoManualTransfer))
    }
    
    var paymentMethod: Int {
        switch self {
        case .internalTransfer:
            return 1
        case .sepaTransfer:
            return 3
        case .swiftTransfer:
            return 2
        case .selfTransfer:
            return 4
        case .localTransfer, .localCustomTransfer:
            return 7
        case .cryptoTransfer:
            return 8
        case .cardTransfer:
            return 100
        case .manualTransfer:
            return 101
        case .cryptoManualTransfer:
            return 102
        case .cardTopUpTransfer:
            return 103
        case .dynamicTransfer, .dynamicLocalTransfer:
            return 104
        case .undefined:
            return 0
        }
    }
    
    var permission: String {
        switch self {
        case .internalTransfer:
            return "client.transfer.internal"
        case .sepaTransfer:
            return "client.transfer.sepa"
        case .swiftTransfer:
            return "client.transfer.swift"
        case .selfTransfer:
            return "client.transfer.self"
        case .localTransfer, .localCustomTransfer:
            return "client.transfer.local"
        case .cryptoTransfer:
            return "client.transfer.crypto"
        case .cardTransfer:
            return "client.transfer.card"
        case .manualTransfer:
            return ""
        case .cryptoManualTransfer:
            return ""
        case .cardTopUpTransfer:
            return ""
        case .dynamicTransfer, .dynamicLocalTransfer:
            return "client.transfer.dynamic"
        case .undefined:
            return ""
        }
    }
    
    var operationType: AccountOperationType {
        switch self {
        case .internalTransfer:
            return .internalType
        case .sepaTransfer:
            return .sepa
        case .swiftTransfer:
            return .swift
        case .selfTransfer:
            return .internalType
        case .localTransfer, .localCustomTransfer:
            return .local
        case .cryptoTransfer:
            return .cryptoTransfer
        case .cardTransfer:
            return .topUpByCard
        case .manualTransfer:
            return .topUpByRequisites
        case .cryptoManualTransfer:
            return .cryptoTransfer
        case .cardTopUpTransfer:
            return .fee
        case .dynamicTransfer, .dynamicLocalTransfer:
            return .dynamicTransfer
        case .undefined:
            return .internalType
        }
    }
    
    var maxDescriptionLength: Int {
        switch self {
        case .internalTransfer:
            return 35
        case .localTransfer, .localCustomTransfer:
            return 18
        default:
            return 140
        }
    }

}

extension TransferTypeEnum: CaseIterable {}

class TransferType: Codable {
    
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
    }
    
    init(type transferType: TransferTypeEnum) {
        type = transferType.type
    }
    
    var transferType: TransferTypeEnum {
        return TransferTypeEnum(type: type)
    }
    
}
