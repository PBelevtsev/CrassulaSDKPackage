public struct CrassulaSDKPackage {
    
    public static let shared = CrassulaSDKPackage()
    
    public private(set) var text = "Hello, World!"

    public init() {
        
    }
    
    public func connect(domain: String) {
        CrassulaConfigManager.shared.connect(domain: domain)
    }
    
}
