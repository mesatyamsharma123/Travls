import UIKit

struct DeviceHelper {
    static var deviceId: String {
        UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }
}
