//
//  Card.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 8/7/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import UIKit

enum CardType: Int8 {
    case virtual = 0
    case plastic = 1
    
    var name : String {
        switch self {
        case .virtual:
            return "virtual"
        case .plastic:
            return "plastic"
        }
    }
}

enum CardStatus: Int8 {
    case new = 0
    case error = 1
    case requested = 2
    case readyToActive = 3
    case active = 4
    case suspended = 5
    case suspendedHolder = 6
    case suspendedPartner = 7
    case blocked = 8
    case declined = 9
    case unknown = 10
    case expired = 11
    case preOrdered = 12
}

enum CardСonversionStatus: Int8 {
    case noteRequested = 0
    case requested = 1
    case completed = 2
}

enum PaymentCardType: String {
    case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay

    static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]

    var regex : String {
        switch self {
        case .Amex:
           return "^3[47][0-9]{5,}$"
        case .Visa:
           return "^4[0-9]{6,}([0-9]{3})?$"
        case .MasterCard:
           return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
        case .Diners:
           return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .Discover:
           return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCB:
           return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .UnionPay:
           return "^(62|88)[0-9]{5,}$"
        case .Hipercard:
           return "^(606282|3841)[0-9]{5,}$"
        case .Elo:
           return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        default:
           return ""
        }
    }
    
    var iconName : String? {
        switch self {
        case .Amex:
           return "ic_amex"
        case .Visa:
           return "ic_visa"
        case .MasterCard:
           return "ic_mastercard"
        case .Diners:
           return "ic_diners"
        case .Discover:
           return "ic_discover"
        case .JCB:
           return "ic_jcb"
        case .UnionPay:
           return "ic_union_pay"
        case .Hipercard: 
           return nil
        case .Elo:
           return nil
        default:
           return nil
        }
    }
    
    var icon : UIImage? {
        if let iconName = self.iconName {
            return UIImage(named: iconName)
        }
        return nil
    }
}

struct CardFeatures: Codable {
    let changePin: Bool
    let showBalance: Bool
    let showPin: Bool
    let switch3ds: Bool
    let switchContactlessPayment: Bool
    let switchOnlinePayment: Bool
    let topUp: Bool
    let virtualToPlastic: Bool
    
    enum CodingKeys: String, CodingKey {
        case changePin = "change_pin"
        case showBalance = "show_balance"
        case showPin = "show_pin"
        case switch3ds = "switch_3ds"
        case switchContactlessPayment = "switch_contactless_payment"
        case switchOnlinePayment = "switch_online_payments"
        case topUp = "top_up"
        case virtualToPlastic = "virtual_to_plastic"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.changePin = try container.decodeIfPresent(Bool.self, forKey: .changePin) ?? false
        self.showBalance = try container.decodeIfPresent(Bool.self, forKey: .showBalance) ?? false
        self.showPin = try container.decodeIfPresent(Bool.self, forKey: .showPin) ?? false
        self.switch3ds = try container.decodeIfPresent(Bool.self, forKey: .switch3ds) ?? false
        self.switchContactlessPayment = try container.decodeIfPresent(Bool.self, forKey: .switchContactlessPayment) ?? false
        self.switchOnlinePayment = try container.decodeIfPresent(Bool.self, forKey: .switchOnlinePayment) ?? false
        self.topUp = try container.decodeIfPresent(Bool.self, forKey: .topUp) ?? false
        self.virtualToPlastic = try container.decodeIfPresent(Bool.self, forKey: .virtualToPlastic) ?? false
    }
}

class Card: NSObject, Decodable {

    var id: String = ""
    var cardType: Int8 = 0
    var type: CardType {
        get {
            return CardType(rawValue: cardType) ?? .virtual
        }
        set(newType) {
            cardType = newType.rawValue
        }
    }
    var cardStatus: Int8 = 2
    var status: CardStatus {
        get {
            let cardStatus = CardStatus(rawValue: self.cardStatus) ?? .new
//            if cardStatus == .requested && -createdAt.timeIntervalSinceNow > 20.0 {
//                cardStatus = .readyToActive
//                self.status = cardStatus
//            }
            return cardStatus
        }
        set(newStatus) {
            cardStatus = newStatus.rawValue
        }
    }
    var cardConversionStatus: Int8 = 2
    var conversionStatus: CardСonversionStatus {
        get {
            return CardСonversionStatus(rawValue: self.cardConversionStatus) ?? .noteRequested
        }
        set(newStatus) {
            cardConversionStatus = newStatus.rawValue
        }
    }
    var createdAt = Date()
    var currency: String = "EUR"
    var settings: CardSettings = CardSettings()
    var provider: String = ""
    var scheme: Int8 = 0
    var mask: String = ""
    var expirationMonth: Int?
    var expirationYear: Int?
    var cardHolder: String = ""
    var account: Account?
    var features: CardFeatures?
    
    var limits = [CardLimit]()
    var spentDetails = [SpentDetails]()
    var pin: String = ""
    
    var limit: Double {
        if let cardLimit = limits.first(where: { (limit) -> Bool in
            return (limit.period == 0)
        }) {
            return cardLimit.amount
        } else {
            return 0.0
        }
    }
    
    var spent: Double {
        if let spentDetail = spentDetails.first(where: { (details) -> Bool in
            return (details.period == 0)
        }) {
            return spentDetail.totalAmount
        } else {
            return 0.0
        }
    }
    
//    var limit: Double = 0.0 {
//        didSet {
//            if limit > 0.0 {
//                spent = Double.random(min: 0.0, max: limit)
//            }
//        }
//    }
//    var spent: Double = 0.0
    
    var info: CardInfo?
    
    var infoNumber: String {
        if let info = info {
            return info.number//.separate()
        }
        return "************" + String(mask.suffix(min(mask.count, 4)))//mask
    }
    
    var infoNumberMasked: String {
        return "*" + String(infoNumber.suffix(min(infoNumber.count, 4)))
    }
    
    var infoExpiration: String {
        if let info = info {
            return String(format: "%02d/%02d", info.expirationMonth, info.expirationYear % 100)
        }
        if let month = expirationMonth,
            let year = expirationYear {
            return String(format: "%02d/%02d", month, year % 100)
        }
        return "XX/XX"
    }
    
    var infoCVC: String {
        if let info = info {
            return info.cvc
        }
        return "***"
    }
    
    var isNotActivated: Bool {
        return (status == .requested) || (status == .readyToActive) || (status == .preOrdered)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case cardType = "type"
        case cardStatus = "status"
        case cardConversionStatus = "conversionStatus"
        case createdAt = "createdAt"
        case currency = "currency"
        case settings = "settings"
        case provider = "provider"
        case scheme = "scheme"
        case mask = "mask"
        case expirationMonth = "expirationMonth"
        case expirationYear = "expirationYear"
        case cardHolder = "cardHolder"
        case account = "account"
        case features = "features"
        case pin = "pin"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.cardType = try container.decodeIfPresent(Int8.self, forKey: .cardType) ?? 0
        self.cardStatus = try container.decodeIfPresent(Int8.self, forKey: .cardStatus) ?? 0
        self.cardConversionStatus = try container.decodeIfPresent(Int8.self, forKey: .cardConversionStatus) ?? 0
        self.createdAt = (try container.decodeIfPresent(String.self, forKey: .createdAt) ?? "").dateValue ?? Date()
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.settings = try container.decodeIfPresent(CardSettings.self, forKey: .settings) ?? CardSettings()
        self.provider = try container.decodeIfPresent(String.self, forKey: .provider) ?? ""
        self.scheme = try container.decodeIfPresent(Int8.self, forKey: .scheme) ?? 0
        self.mask = try container.decodeIfPresent(String.self, forKey: .mask) ?? ""
        self.expirationMonth = try container.decodeIfPresent(Int.self, forKey: .expirationMonth)
        self.expirationYear = try container.decodeIfPresent(Int.self, forKey: .expirationYear)
        self.cardHolder = try container.decodeIfPresent(String.self, forKey: .cardHolder) ?? ""
        self.account = try container.decodeIfPresent(Account.self, forKey: .account)
        do {
            self.features = try container.decodeIfPresent(CardFeatures.self, forKey: .features)
        } catch { }
        self.pin = try container.decodeIfPresent(String.self, forKey: .pin) ?? ""
    }
    
    override init() {
        super.init()
    }
    
    init(cardType: CardType) {
        super.init()
        self.type = cardType
        if cardType == .virtual {
            status = .active
        }
    }
    
    var canBeActivatedToPlastic: Bool {
        return (type == .virtual) && (conversionStatus == .requested)
    }
    
    var isCreated: Bool {
        return (status == .preOrdered) || (status == .requested) ||
            (status == .readyToActive) || (status == .active) ||
            (status == .suspended) || (status == .suspendedHolder) || (status == .suspendedPartner)
    }
    
    var isFailed: Bool {
        return (status == .error) || (status == .declined)
    }
}
