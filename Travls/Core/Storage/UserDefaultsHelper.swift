import Foundation

enum UserDefaultsKey: String {
    case userId              = "com.travls.userId"
    case userName            = "com.travls.userName"
    case hasSeenOnboarding   = "com.travls.hasSeenOnboarding"
}

final class UserDefaultsHelper {
    static let shared = UserDefaultsHelper()
    private let defaults = UserDefaults.standard
    private init() {}

    func set(_ value: Any?, key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }

    func string(key: UserDefaultsKey) -> String? {
        defaults.string(forKey: key.rawValue)
    }

    func bool(key: UserDefaultsKey) -> Bool {
        defaults.bool(forKey: key.rawValue)
    }

    func clearAll() {
        guard let domain = Bundle.main.bundleIdentifier else { return }
        defaults.removePersistentDomain(forName: domain)
    }
}
