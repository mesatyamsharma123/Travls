import Foundation
import CryptoKit

final class PINManager {
    static let shared = PINManager()
    private init() {}

    func savePIN(_ pin: String) {
        KeychainHelper.shared.save(hash(pin), key: .pin)
    }

    func verifyPIN(_ pin: String) -> Bool {
        guard let stored = KeychainHelper.shared.read(key: .pin) else { return false }
        return hash(pin) == stored
    }

    func hasPIN() -> Bool {
        KeychainHelper.shared.read(key: .pin) != nil
    }

    func clearPIN() {
        KeychainHelper.shared.delete(key: .pin)
    }

    private func hash(_ pin: String) -> String {
        SHA256.hash(data: Data(pin.utf8))
            .compactMap { String(format: "%02x", $0) }
            .joined()
    }
}
