//
//  CrassulaUserManager.swift
//  CrassulaSDK
//
//  Created by Pavel Belevtsev on 08.07.2023.
//

import Foundation
import Alamofire

class CrassulaUserManager {
    
    static let shared = CrassulaUserManager()
    
    var token: Token? = nil
    
    func signIn(email : String, password : String, captchaToken: String? = nil, _ completionHandler: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        
        guard let apiUrl = CrassulaConfigManager.shared.apiUrl else {
            completionHandler(false, nil)
            return
        }
        
        let data = ["username": email, "password": password]
        AF.request(apiUrl.appendingPathComponent("public/authenticate"), method: .post, parameters: data, encoder: .json).responseDecodable(of: Token.self) { [weak self] response in
            self?.token = response.value
            completionHandler(response.value != nil, response.error)
        }
    }

    var headers: [String : String]? {
        guard let tokenValue = token?.token else {
            return nil
        }
     
        return ["Authorization": "Bearer \(tokenValue)",
                "Accept": "application/json",
                "Content-Type": "application/json" ]
    }
    
    var clientId: String? {
        return token?.clientId
    }
    
    public func accounts(_ completionHandler: @escaping (_ accounts: [Account]?, _ error: Error?) -> ()) {
        
        guard let apiUrl = CrassulaConfigManager.shared.apiUrl,
              let headers = headers,
              let clientId = clientId else {
            completionHandler(nil, nil)
            return
        }
     
        AF.request(apiUrl.appendingPathComponent("clients/\(clientId)/accounts"), headers: HTTPHeaders(headers)).responseDecodable(of: [Account].self) { response in
            
            completionHandler(response.value, response.error)
        }
    }
    
    public func transactions(limit: Int = 100, page: Int = 1, filters: [RequestFilter], _ completionHandler: @escaping (_ transactions: Transactions?, _ error: Error?) -> ()) {
        
        guard let apiUrl = CrassulaConfigManager.shared.apiUrl,
              let headers = headers,
              let clientId = clientId else {
            completionHandler(nil, nil)
            return
        }
        
        var rFilters: [RequestFilter] = [RequestPaginationFilter(limit: limit, page: page)]
        rFilters.append(contentsOf: filters)
        let params = ["filter": RequestFilter.param(rFilters)]
     
        AF.request(apiUrl.appendingPathComponent("clients/\(clientId)/transactions"), parameters: params, headers: HTTPHeaders(headers)).responseDecodable(of: Transactions.self) { response in
            
            completionHandler(response.value, response.error)
        }
    }
}
