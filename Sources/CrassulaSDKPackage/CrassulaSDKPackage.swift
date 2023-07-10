public struct CrassulaSDKPackage {
    
    public static let shared = CrassulaSDKPackage()
    
    public private(set) var text = "Hello, World!"

    public init() {
        
    }
    
    public func connect(domain: String, _ completionHandler: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        CrassulaConfigManager.shared.connect(domain: domain, completionHandler)
    }
    
    public func signIn(email : String, password : String, captchaToken: String? = nil, _ completionHandler: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        
        CrassulaUserManager.shared.signIn(email: email, password: password, completionHandler)
    }
    
    public func accounts(_ completionHandler: @escaping (_ accounts: [Account]?, _ error: Error?) -> ()) {
        
        CrassulaUserManager.shared.accounts(completionHandler)
    }
}
