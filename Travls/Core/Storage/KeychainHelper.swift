import Foundation
import Security

enum KeychainKey: String {
    case accessToken  = "com.travls.accessToken"
    case refreshToken = "com.travls.refreshToken"
    case pin          = "com.travls.pin"
}

final class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}

    func save(_ value: String, key: KeychainKey) {
        let data = Data(value.utf8)
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData:   data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func read(key: KeychainKey) -> String? {
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData:  true,
            kSecMatchLimit:  kSecMatchLimitOne
        ]
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func delete(key: KeychainKey) {
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ]
        SecItemDelete(query as CFDictionary)
    }

    func deleteAll() {
        KeychainKey.allCases.forEach { delete(key: $0) }
    }
}

extension KeychainKey: CaseIterable {}
