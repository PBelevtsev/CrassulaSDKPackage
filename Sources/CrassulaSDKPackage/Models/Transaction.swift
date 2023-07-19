//
//  Transaction.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 3/31/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public enum TransactionStatus: Int8 {
    case draft = 0
    case pending = 1
    case completed = 2
    case declined = 3
    case refunded = 4
}

public enum TransactionType: Int8 {
    case deposit = 0
    case fee = 1
    case refund = 2
    case transfer = 4
    case systemDeposit = 5
    case currencyConversion = 6
    case recall = 7
    case cardPurchase = 8
    case cardWithdrawal = 9
    case vaultInterest = 12
    case vaultWithdrawal = 13
}

public class Transaction: Decodable {
    
    public let id: String
    public let beneficiaryAccountNumber: String
    public let beneficiaryAccountIban: String
    public let transactionDescription: String
    public let provider: String
    public let remitterName: String
    public let beneficiaryType: Int8
    public let amount: Double
    public let type: Int8
    public let bankDetails: Bank?
    public let beneficiaryName: String
    public let remitterAccountNumber: String
    public let account: Account?
    public let accountNumber: String
    public let currency: String
    public let status: Int8
    public let createdAtText: String
    public let createdAt: Date?
    public let updatedAt: Date?
        
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case beneficiaryAccountNumber = "beneficiaryAccountNumber"
        case beneficiaryAccountIban = "beneficiaryAccountIban"
        case transactionDescription = "description"
        case provider = "providerType"
        case remitterName = "remitterName"
        case beneficiaryType = "beneficiary_type"
        case amount = "amount"
        case type = "type"
        case bankDetails = "bankDetails"
        case beneficiaryName = "beneficiaryName"
        case remitterAccountNumber = "remitterAccountNumber"
        case account = "account"
        case currency = "currency"
        case status = "status"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.beneficiaryAccountNumber = try container.decodeIfPresent(String.self, forKey: .beneficiaryAccountNumber) ?? ""
        self.beneficiaryAccountIban = try container.decodeIfPresent(String.self, forKey: .beneficiaryAccountIban) ?? ""
        self.transactionDescription = try container.decodeIfPresent(String.self, forKey: .transactionDescription) ?? ""
        self.provider = try container.decodeIfPresent(String.self, forKey: .provider) ?? ""
        self.remitterName = try container.decodeIfPresent(String.self, forKey: .remitterName) ?? ""
        self.beneficiaryType = try container.decodeIfPresent(Int8.self, forKey: .beneficiaryType) ?? 0
        self.amount = try container.decodeIfPresent(Double.self, forKey: .amount) ?? 0.0
        self.type = try container.decodeIfPresent(Int8.self, forKey: .type) ?? 0
        self.bankDetails = try container.decodeIfPresent(Bank.self, forKey: .bankDetails)
        self.beneficiaryName = try container.decodeIfPresent(String.self, forKey: .beneficiaryName) ?? ""
        self.remitterAccountNumber = try container.decodeIfPresent(String.self, forKey: .remitterAccountNumber) ?? ""
        self.account = try container.decodeIfPresent(Account.self, forKey: .account)
        self.accountNumber = account?.number ?? ""
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.status = try container.decodeIfPresent(Int8.self, forKey: .status) ?? 0
        self.createdAt = (try container.decodeIfPresent(String.self, forKey: .createdAt) ?? "").dateValue
        self.createdAtText = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        self.updatedAt = (try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? "").dateValue
    }
    
    public var transferType: TransferTypeEnum {
        return TransferTypeEnum(type: provider)
    }
    
    public var typeValue: TransactionType {
        return TransactionType(rawValue: type) ?? .deposit
    }
    
    public var statusValue: TransactionStatus {
        return TransactionStatus(rawValue: status) ?? .draft
    }
    
    public var remitterAccount: String {
        if let bankDetails = bankDetails,
            let bankAccountNumber = bankDetails.bankAccountNumber {
            return bankAccountNumber
        } else {
            return remitterAccountNumber
        }
    }
    
    public var beneficiaryAccount: String {
        if let bankDetails = bankDetails,
            let bankAccountNumber = bankDetails.bankAccountNumber {
            return bankAccountNumber
        } else {
            return beneficiaryAccountNumber
        }
    }
    
    public var beneficiaryMaskedAccount: String? {
        if beneficiaryAccountIban.count > 12 {
            return beneficiaryAccountIban.prefix(6) + "***" + beneficiaryAccountIban.suffix(4)
        } else {
            return nil
        }
    }
}

public class Transactions: Decodable {
    
    public let totalCount: Int64
    public let transactions: [Transaction]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "totalCount"
        case transactions = "transactions"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalCount = try container.decodeIfPresent(Int64.self, forKey: .totalCount) ?? 0
        self.transactions = try container.decodeIfPresent([Transaction].self, forKey: .transactions) ?? [Transaction]()
    }

}
