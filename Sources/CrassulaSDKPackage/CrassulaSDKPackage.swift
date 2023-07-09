public struct CrassulaSDKPackage {
    public private(set) var text = "Hello, World!"

    public init() {
    }
    
    func connect(domain: String) {
        CrassulaConfigManager.shared.connect(domain: domain)
    }
    
}
