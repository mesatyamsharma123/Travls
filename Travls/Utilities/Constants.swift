import Foundation

enum Constants {
    enum API {
        static let timeoutInterval: TimeInterval = 30
    }

    enum Pagination {
        static let defaultPageSize = 20
    }

    enum Animation {
        static let defaultDuration: Double = 0.3
        static let springResponse: Double = 0.4
        static let springDamping: Double = 0.75
    }
}
