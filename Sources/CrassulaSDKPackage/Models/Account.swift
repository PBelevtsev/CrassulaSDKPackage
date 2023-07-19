//
//  Account.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 3/30/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import UIKit
import CoreData

enum AccountOperationType : String, CaseIterable {
    case internalType = "internal"
    case swift = "swift"
    case sepa = "sepa"
    case local = "local"
    case payout = "payout"
    case fee = "fee"
    case exchange = "exchange"
    case topUpByCard = "top_up_by_card"
    case topUpByRequisites = "top_up_by_requisites"
    case dynamicTransfer = "dynamic_transfer"
    case cryptoTransfer = "crypto_transfer"
}

public class Account: Decodable {
    var number: String = ""
    var status: Int8 = 0
    var type: Int8 = 0
    var primary: Bool = false
    var iban: String? //
    var clientName: String = ""
    var clientType: Int8 = 0
    var createdAt: String = ""
    public var name: String = ""
    var providerNumber: String?
    var providerCurrency: String = ""
    var metadata: [String: Any]?
    var cards: [Card] = [Card]()
    private var balancesData: [Balance]?
    var prohibitedOperations: [String: Any]?
    var provider: AccountProvider?
    var dynamicPayment: Bool = false
    private var availableOperationsList: [AccountOperationType]?
    var availableOperations: [AccountOperationType] {
        if let availableOperationsList = self.availableOperationsList {
            return availableOperationsList
        } else {
            var operations = [AccountOperationType]()
            for type in AccountOperationType.allCases {
                if let operations = prohibitedOperations,
                   let operation = operations[type.rawValue] as? Bool,
                   operation {
//                    print("prohibitedOperation \(type.rawValue)")
                } else {
                    operations.append(type)
                }
            }
            availableOperationsList = operations
            return operations
        }
    }
    var balances: [Balance]? {
        set {
            balancesData = newValue
        }
        get {
            let currencies = provider?.currencies ?? [String]()
            if currencies.count > 0 {
                var result = [Balance]()
                for currency in currencies {
                    if let balancesData = balancesData,
                       let balance = balancesData.first(where: { $0.currency == currency }) {
                        result.append(balance)
                    } else {
                        result.append(Balance(currency: currency, current: 0.0, reserved: 0.0, available: 0.0))
                    }
                }
                return result
            } else {
                if let balancesData = balancesData,
                   balancesData.count > 0 {
                    return balancesData
                } else {
                    var currency = providerCurrency
                    if currency.count == 0 {
                        currency = "EUR"
                    }
                    let emptyBalance = Balance(currency: currency, current: 0.0, reserved: 0.0, available: 0.0)
                    return [emptyBalance]
                }
            }
        }
    }
    var icon: String {
        var index = 0
        let numbers = Array(number)
        for num in numbers {
            index += Int(String(num)) ?? 0
        }
        return "gradient_\(index % 20)"
    }
    
    var createAtDate: Date {
        return createdAt.dateValue ?? Date()
    }
    
    var ibanFormatted: String {
        if let iban = iban {
            return iban.separate()
        } else {
            return number
        }
    }
    
    var isCardIssuer: Bool {
        return provider?.cardIssuer ?? false
    }
    
    var availableCurrencies: [String] {
        if let providerCurrences = provider?.currencies,
           providerCurrences.count > 0 {
            return providerCurrences
        } else if let balances = balances {
            return balances.map({ $0.currency })
        } else {
            return [String]()
        }
    }
    enum CodingKeys: String, CodingKey {
        case number = "number"
        case status = "status"
        case type = "type"
        case primary = "primary"
        case iban = "iban"
        case clientName = "clientName"
        case clientType = "clientType"
        case createdAt = "createdAt"
        case name = "name"
        case providerNumber = "providerNumber"
        case providerCurrency = "providerCurrency"
        case metadata = "metadata"
        case cards = "cards"
        case balances = "balances"
        case prohibitedOperations = "prohibitedOperations"
        case provider = "provider"
        case dynamicPayment = "dynamicPayment"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.number = try container.decodeIfPresent(String.self, forKey: .number) ?? ""
        self.status = try container.decodeIfPresent(Int8.self, forKey: .status) ?? 0
        self.type = try container.decodeIfPresent(Int8.self, forKey: .type) ?? 0
        self.primary = try container.decodeIfPresent(Bool.self, forKey: .primary) ?? false
        self.iban = try container.decodeIfPresent(String.self, forKey: .iban)
        self.clientName = try container.decodeIfPresent(String.self, forKey: .clientName) ?? ""
        self.clientType = try container.decodeIfPresent(Int8.self, forKey: .clientType) ?? 0
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.providerNumber = try container.decodeIfPresent(String.self, forKey: .providerNumber)
        let providerCurrency = try container.decodeIfPresent(String.self, forKey: .providerCurrency) ?? ""
        self.providerCurrency = providerCurrency
        do {
            self.metadata = try container.decodeIfPresent([String: Any].self, forKey: .metadata)
        } catch { }
        self.cards = try container.decodeIfPresent([Card].self, forKey: .cards) ?? [Card]()
        self.balancesData = try container.decodeIfPresent([Balance].self, forKey: .balances) ?? [Balance]()
        do {
            self.prohibitedOperations = try container.decodeIfPresent([String: Any].self, forKey: .prohibitedOperations)
        } catch { }
        self.provider = try container.decodeIfPresent(AccountProvider.self, forKey: .provider)
        self.dynamicPayment = try container.decodeIfPresent(Bool.self, forKey: .dynamicPayment) ?? true
    }
    
    func balanceAvailable(currency: String) -> Double {
        
        var result = 0.0
        
        if let balances = self.balances {
            if let data = balances.first(where: { (item) -> Bool in
                return item.currency == currency
            }) {
                result = data.available
            }
        }
        
        return result
    }
    
    func balanceExist(currency: String) -> Bool {
        
        if let balances = self.balances {
            if let _ = balances.first(where: { $0.currency == currency }) {
                return true
            }
        }
        return false
    }
    
    func metadataRailsbank() -> [String : String]? {
        return metadata?["railsbank"] as? [String : String]
    }
    
    func isActive() -> Bool {
        return (status == 1)
    }
    
    func isClosed() -> Bool {
        return (status == 2) || (status == 3) || (status == 4)
    }
    
    func isCrypto() -> Bool {
        return (type == 2)
    }
    
    func isAllowed(currency: String) -> Bool {
        if currency.count == 0 {
            return true
        }
        if providerCurrency.count > 0 {
            return (providerCurrency == currency)
        }
        return true
    }
    
    func activeCards(type: CardType) -> [Card] {
        return cards.filter { ($0.type == type) && ($0.status != .declined) && ($0.status != .blocked) }
    }
    
    func cardWith(id: String) -> Card? {
        return cards.first(where: { $0.id == id } )
    }
    
    func hasPositiveBalance() -> Bool {
        if let balances = balances {
            return (balances.filter({ $0.available > 0.0 }).count > 0)
        }
        return false
    }
}

class AccountProvider: Decodable {
    var cardIssuer: Bool = false
    var currencies: [String] = [String]()
    var currency: String? = nil
    var name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case cardIssuer = "cardIssuer"
        case currencies = "currencies"
        case currency = "currency"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cardIssuer = try container.decodeIfPresent(Bool.self, forKey: .cardIssuer) ?? false
        self.currencies = try container.decodeIfPresent([String].self, forKey: .currencies) ?? [String]()
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
    
}
