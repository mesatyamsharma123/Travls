import Foundation

struct Configuration {

    static var shared = Configuration()

    private init() {
        if
            let value = UserDefaults.standard.string(forKey: "SelectedConfiguration"),
            let environment = Environment(rawValue: value)
        {
            selectedEnvironment = environment
            return
        }

        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            let cleanConfig = configuration.trimmingCharacters(in: .whitespacesAndNewlines)
            switch cleanConfig {
            case "Debug":   selectedEnvironment = .development
            case "Staging": selectedEnvironment = .staging
            case "Release": selectedEnvironment = .release
            default:        break
            }
        }
    }

    // MARK: - Environment

    enum Environment: String {

        case development
        case staging
        case release

        // MARK: Base URL

        var baseURL: String {
            switch self {
            case .development: return "https://dev-api.travls.io/v1"
            case .staging:     return "https://staging-api.travls.io/v1"
            case .release:     return "https://api.travls.io/v1"
            }
        }

        // MARK: Auth Service

        var authBaseURL: String {
            switch self {
            case .development: return "https://dev-auth.travls.io"
            case .staging:     return "https://staging-auth.travls.io"
            case .release:     return "https://auth.travls.io"
            }
        }

        // MARK: Wallet / Payments Service

        var walletBaseURL: String {
            switch self {
            case .development: return "https://dev-wallet.travls.io"
            case .staging:     return "https://staging-wallet.travls.io"
            case .release:     return "https://wallet.travls.io"
            }
        }

        // MARK: Media / CDN

        var mediaBaseURL: String {
            switch self {
            case .development: return "https://dev-media.travls.io"
            case .staging:     return "https://staging-media.travls.io"
            case .release:     return "https://media.travls.io"
            }
        }

        // MARK: Feature Flags

        var isAccessibilityEnabled: Bool {
            return self != .release
        }

        // MARK: App Info

        var appVersion: String {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        }

        var buildNumber: String {
            return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        }
    }

    // MARK: - Active Environment

    var environment: Environment {
        if isConfigurationChangeEnabled {
            return selectedEnvironment
        }

        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            let cleanConfig = configuration.trimmingCharacters(in: .whitespacesAndNewlines)
            switch cleanConfig {
            case "Debug":   return .development
            case "Staging": return .staging
            case "Release": return .release
            default:        break
            }
        }

        return .release
    }

    var selectedEnvironment: Environment = .development {
        didSet {
            if isConfigurationChangeEnabled {
                UserDefaults.standard.set(selectedEnvironment.rawValue, forKey: "SelectedConfiguration")
            }
        }
    }

    // MARK: - Debug Gates

    var isFeaturesLauncherEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    var isConfigurationChangeEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
