//
//  Bank.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 3/31/19.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import Foundation

public class Bank: Decodable {
    let number: String?
    let bankCountryCode: String?
    let beneficiaryAddress: String?
    let correspondentBankCode: String?
    let beneficiaryState: String?
    let beneficiaryCountryCode: String?
    let bankName: String?
    let beneficiaryCode: String?
    let bankAddress: String?
    let beneficiaryTaxCode: String?
    let beneficiaryCity: String?
    let bankAccountNumber: String?
    let correspondentBankAccountNumber: String?
    let beneficiaryName: String?
    let bic: String?
    let correspondentBankName: String?
    let beneficiaryAdditionalCode: String?
    let beneficiaryPostalCode: String?
    
}
