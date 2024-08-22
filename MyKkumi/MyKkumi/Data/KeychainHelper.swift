import Security
import Foundation

class KeychainHelper {
    static let shared = KeychainHelper()
    
    private init() {}
    
    func save(_ token: String, key: String) -> Bool {
        let query : NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : key,
            kSecValueData : token.data(using: .utf8, allowLossyConversion : false)!
        ]
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        
        return status == errSecSuccess
    }
    
    func load(key: String) -> String? {
        let query: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : key,
            kSecReturnAttributes : true,
            kSecReturnData : true
        ]
        
        var dataTypeRef: CFTypeRef?
        let status = SecItemCopyMatching(query , &dataTypeRef)
        
        if status == errSecSuccess {
            guard let checkedItem = dataTypeRef,
                  let token = checkedItem[kSecValueData] as? Data else { return nil }
            return String(data: token, encoding: String.Encoding.utf8)
        }
        
        return nil
    }
    
    func delete(key: String) {
        let query: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : key
        ]
        
        SecItemDelete(query)
    }
}
