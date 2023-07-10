//
//  CrassulaConfigManager.swift
//  CrassulaSDK
//
//  Created by Pavel Belevtsev on 08.07.2023.
//

import Foundation
import Alamofire

class CrassulaConfigManager {
    
    static let shared = CrassulaConfigManager()
    
    var apiUrl: URL? = nil
    var settings: Settings? = nil
    
    func connect(domain: String, _ completionHandler: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        if let url = URL(string: domain) {
            self.apiUrl = url.appendingPathComponent("api")
            if let apiUrl = apiUrl {
                
                AF.request(apiUrl.appendingPathComponent("public/settings")).responseDecodable(of: Settings.self) { [weak self] response in
                    self?.settings = response.value
                    completionHandler(response.value != nil, response.error)
                }
//                AF.request(apiUrl.appendingPathComponent("public/settings")).responseJSON { response in
//                    print(response)
//                }
            } else {
                completionHandler(false, nil)
            }
        } else {
            completionHandler(false, nil)
        }
        
    }
    
}
