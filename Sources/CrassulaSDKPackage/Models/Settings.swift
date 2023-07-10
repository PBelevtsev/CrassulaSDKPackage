//
//  Settings.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 9/2/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import UIKit

class Settings: Decodable {
    let defaultLanguage: String
    let whiteLabelName: String
    let publicKey: String
    let helpEmail: String
    var allowedCurrencies: [Currency]
    let allowMultipleAccountsPerCurrency: Bool
    let allowMultipleAccountsPerCryptoCurrency: Bool
    let allowMultiCurrencyAccounts: Bool
    let rememberMe: Bool
    let tfaRequired: Bool
    let features: [String: Any]?
    let bankTransferAccountIbanRequired: Bool
    let bankTransfersAccountIbanRequired: [String: Bool]
    let identificationProvider: String// "sumsub"
    let showAccountCurrencies: Bool
    let availableCountries: [String]
    let availableTransferCountries: [String]
    let excludedCountries: [String]
    let excludedTransferCountries: [String]
    let preferredOrderCountries: [String]
    let bankTransfersInternationalCurrencies: [String]
    let bankTransfersSepaCurrencies: [String]
    let cryptoWithdrawalLimitList: [CryptoWithdrawalLimit]
    let captchaSiteKeys: CaptchaSiteKeys?
    let captchaSupportedDevices: [String]
    let cardIssuingProviders: [String]
    let issuedCardProviderCurrencies: [String]
    
    enum CodingKeys: String, CodingKey {
        case defaultLanguage = "defaultLanguage"
        case whiteLabelName = "whiteLabelName"
        case publicKey = "publicKey"
        case helpEmail = "helpEmail"
        case allowedCurrencies = "allowedCurrencies"
        case allowMultipleAccountsPerCurrency = "allowMultipleAccountsPerCurrency"
        case allowMultipleAccountsPerCryptoCurrency = "allowMultipleAccountsPerCryptoCurrency"
        case allowMultiCurrencyAccounts = "allowMultiCurrencyAccounts"
        case rememberMe = "rememberMe"
        case tfaRequired = "tfaRequired"
        case features = "features"
        case bankTransferAccountIbanRequired = "bankTransferAccountIbanRequired"
        case bankTransfersAccountIbanRequired = "bankTransfersAccountIbanRequired"
        case identificationProvider = "identificationProvider"
        case showAccountCurrencies = "showAccountCurrencies"
        case availableCountries = "availableCountries"
        case availableTransferCountries = "availableTransferCountries"
        case excludedCountries = "excludedCountries"
        case excludedTransferCountries = "excludedTransferCountries"
        case preferredOrderCountries = "preferredOrderCountries"
        case bankTransfersInternationalCurrencies = "bankTransfersInternationalCurrencies"
        case bankTransfersSepaCurrencies = "bankTransfersSepaCurrencies"
        case cryptoWithdrawalLimitList = "cryptoWithdrawalLimitList"
        case captchaSiteKeys = "captchaSiteKeys"
        case captchaSupportedDevices = "captchaSupportedDevices"
        case cardIssuingProviders = "cardIssuingProviders"
        case issuedCardProviderCurrencies = "issuedCardProviderCurrencies"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.defaultLanguage = try container.decodeIfPresent(String.self, forKey: .defaultLanguage) ?? "en"
        self.whiteLabelName = try container.decodeIfPresent(String.self, forKey: .whiteLabelName) ?? ""
        self.publicKey = try container.decodeIfPresent(String.self, forKey: .publicKey) ?? ""
        self.helpEmail = try container.decodeIfPresent(String.self, forKey: .helpEmail) ?? ""
        self.allowedCurrencies = try container.decodeIfPresent([Currency].self, forKey: .allowedCurrencies) ?? []
        self.allowMultipleAccountsPerCurrency = try container.decodeIfPresent(Bool.self, forKey: .allowMultipleAccountsPerCurrency) ?? false
        self.allowMultipleAccountsPerCryptoCurrency = try container.decodeIfPresent(Bool.self, forKey: .allowMultipleAccountsPerCryptoCurrency) ?? false
        self.allowMultiCurrencyAccounts = try container.decodeIfPresent(Bool.self, forKey: .allowMultiCurrencyAccounts) ?? false
        self.rememberMe = try container.decodeIfPresent(Bool.self, forKey: .rememberMe) ?? false
        self.tfaRequired = try container.decodeIfPresent(Bool.self, forKey: .tfaRequired) ?? false
        self.features = try container.decodeIfPresent([String: Any].self, forKey: .features)
        self.bankTransferAccountIbanRequired = try container.decodeIfPresent(Bool.self, forKey: .bankTransferAccountIbanRequired) ?? false
        self.bankTransfersAccountIbanRequired = try container.decodeIfPresent([String: Bool].self, forKey: .bankTransfersAccountIbanRequired) ?? [String: Bool]()
        self.identificationProvider = try container.decodeIfPresent(String.self, forKey: .identificationProvider) ?? ""
        self.showAccountCurrencies = try container.decodeIfPresent(Bool.self, forKey: .showAccountCurrencies) ?? false
        self.availableCountries = try container.decodeIfPresent([String].self, forKey: .availableCountries) ?? []
        self.availableTransferCountries = try container.decodeIfPresent([String].self, forKey: .availableTransferCountries) ?? []
        self.excludedCountries = try container.decodeIfPresent([String].self, forKey: .excludedCountries) ?? []
        self.excludedTransferCountries = try container.decodeIfPresent([String].self, forKey: .excludedTransferCountries) ?? []
        self.preferredOrderCountries = try container.decodeIfPresent([String].self, forKey: .preferredOrderCountries) ?? []
        self.bankTransfersInternationalCurrencies = try container.decodeIfPresent([String].self, forKey: .bankTransfersInternationalCurrencies) ?? []
        self.bankTransfersSepaCurrencies = try container.decodeIfPresent([String].self, forKey: .bankTransfersSepaCurrencies) ?? []
        self.cryptoWithdrawalLimitList = try container.decodeIfPresent([CryptoWithdrawalLimit].self, forKey: .cryptoWithdrawalLimitList) ?? []
        self.captchaSiteKeys = try container.decodeIfPresent(CaptchaSiteKeys.self, forKey: .captchaSiteKeys)
        self.captchaSupportedDevices = try container.decodeIfPresent([String].self, forKey: .captchaSupportedDevices) ?? []
        self.cardIssuingProviders = try container.decodeIfPresent([String].self, forKey: .cardIssuingProviders) ?? []
        self.issuedCardProviderCurrencies = try container.decodeIfPresent([String].self, forKey: .issuedCardProviderCurrencies) ?? []
    }

    func feature(_ key: String) -> String? {
        guard let data = features else {
            return nil
        }
        
        return feature(data, key.components(separatedBy: "."))
    }
    
    private func feature(_ data: [String: Any], _ path: [String]) -> String? {
        let key = path[0]
        if path.count > 1 {
            if let dataNext = data[key] as? [String: Any] {
                return feature(dataNext, path.suffix(path.count - 1))
            }
        } else {
            if let _ = data[key] as? [String: Any] {
                return "true"
            } else if let result = data[key] as? Bool {
                return result ? "true" : nil
            }
        }
        
        return nil
    }
}

class CryptoWithdrawalLimit: Codable {
    let amount: Double
    let currency: String
    let provider: String
    let status: Int
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case currency = "currency"
        case provider = "provider"
        case status = "status"
        case type = "type"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.amount = try container.decodeIfPresent(Double.self, forKey: .amount) ?? 0.0
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.provider = try container.decodeIfPresent(String.self, forKey: .provider) ?? ""
        self.status = try container.decodeIfPresent(Int.self, forKey: .status) ?? 0
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
    }
}

class CaptchaSiteKeys: Codable {
    let android: String
    let ios: String
    let web: String
    
    enum CodingKeys: String, CodingKey {
        case android = "android"
        case ios = "ios"
        case web = "web"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.android = try container.decodeIfPresent(String.self, forKey: .android) ?? ""
        self.ios = try container.decodeIfPresent(String.self, forKey: .ios) ?? ""
        self.web = try container.decodeIfPresent(String.self, forKey: .web) ?? ""
    }
}
