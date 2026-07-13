import Foundation

enum Environment {
    case development
    case staging
    case production

    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}

final class Configuration {
    static let shared = Configuration()
    private init() {}

    var baseURL: URL {
        switch Environment.current {
        case .development: return URL(string: "https://dev-api.travls.io/v1")!
        case .staging:     return URL(string: "https://staging-api.travls.io/v1")!
        case .production:  return URL(string: "https://api.travls.io/v1")!
        }
    }

    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}
