//
//  RequestFilters.swift
//  Crassula
//
//  Created by Pavel Belevtsev on 15.11.2019.
//  Copyright © 2019 CratechOU. All rights reserved.
//

import Foundation

public class RequestFilter {
    
    public init() {
        
    }
    
    func paramValue() -> [String : Any] {
        return [:]
    }
    
    static func param(_ filters: [RequestFilter]?) -> [String : Any] {
        
        var paramFilter = [String : Any]()
        if filters != nil {
            for filter in filters! {
                let paramValue = filter.paramValue()
                paramValue.forEach { (k,v) in paramFilter[k] = v }
            }
        }
        return paramFilter
    }
    
}

public class RequestAccountFilter: RequestFilter {
    let account: Account
    
    public init(_ account: Account) {
        self.account = account
    }
    
    override func paramValue() -> [String : Any] {
        return ["account" : account.number]
    }
    
}

class RequestPaginationFilter: RequestFilter {
    var limit: Int = 100
    var page: Int = 1
    
    init(limit: Int = 100, page: Int = 1) {
        super.init()
        
        self.limit = limit
        self.page = page
    }
    
    override func paramValue() -> [String : Any] {
        return ["limit" : limit, "page" : page, "pagination" : "true"]
    }
    
}

public class RequestDateIntervalFilter: RequestFilter {
    let start: Date
    let end: Date
    
    public init(_ start: Date, _ end: Date) {
        self.start = start
        self.end = end
    }
    
    override func paramValue() -> [String : Any] {
        return ["period" : ["from": start.string(), "to": end.string()]]
    }
}

public class RequestDebitFilter: RequestFilter {
    
    override func paramValue() -> [String : Any] {
        return ["debit" : "true"]
    }
    
}

public class RequestCreditFilter: RequestFilter {
    
    override func paramValue() -> [String : Any] {
        return ["credit" : "true"]
    }
    
}

public class RequestStatusFilter: RequestFilter {
    
    let status: TransactionStatus
    
    public init(_ status: TransactionStatus) {
        self.status = status
    }
    
    override func paramValue() -> [String : Any] {
        return ["status" : [0 : status.rawValue]]
    }
    
}

class RequestStatusDraftFilter: RequestStatusFilter {
    public init() {
        super.init(.draft)
    }
}

public  class RequestReloadDateFilter: RequestFilter {
    let date: Date
    
    public init(_ date: Date) {
        self.date = date
    }
    
    override func paramValue() -> [String : Any] {
        return ["updated" : ["from": date.string()]]
    }
    
}

public class RequestTypeFilter: RequestFilter {
    
    let type: TransactionType
    
    public init(_ type: TransactionType) {
        self.type = type
    }
    
    override func paramValue() -> [String : Any] {
        return ["type" : [0 : type.rawValue]]
    }
    
}
