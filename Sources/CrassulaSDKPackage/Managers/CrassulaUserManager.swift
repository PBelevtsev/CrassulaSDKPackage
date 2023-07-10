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

    public func accounts(_ completionHandler: @escaping (_ accounts: [Account]?, _ error: Error?) -> ()) {
        
        guard let apiUrl = CrassulaConfigManager.shared.apiUrl,
              let tokenValue = token?.token,
              let clientId = token?.clientId else {
            completionHandler(nil, nil)
            return
        }
     
        let headers = [
                    "Authorization": "Bearer \(tokenValue)",
                    "Accept": "application/json",
                    "Content-Type": "application/json" ]
        
        AF.request(apiUrl.appendingPathComponent("clients/\(clientId)/accounts"), headers: HTTPHeaders(headers)).responseDecodable(of: [Account].self) { response in
            
            completionHandler(response.value, response.error)
        }
    }
}
