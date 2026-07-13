import LocalAuthentication
import Foundation

final class BiometricManager {
    static let shared = BiometricManager()
    private init() {}

    var isFaceIDAvailable: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            && context.biometryType == .faceID
    }

    func authenticateWithFaceID() async -> Bool {
        let context = LAContext()
        return await withCheckedContinuation { continuation in
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Unlock Travls with Face ID"
            ) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }
}
