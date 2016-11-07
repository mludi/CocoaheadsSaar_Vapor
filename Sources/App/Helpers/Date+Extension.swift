import Foundation

extension Date {
    func current() -> String {
        return DateFormatter.CurrentDateTime.string(from: self)
    }
}

extension DateFormatter {
    @nonobjc static let CurrentDateTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
}
