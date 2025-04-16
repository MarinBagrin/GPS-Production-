import Foundation
protocol Validator {
    associatedtype Value
    func validate(_ value: Value) -> Bool
}

class IpValidator: Validator {
    func validate(_ value: String) -> Bool {
        let allowedChars = CharacterSet(charactersIn: "1234567890.")
        let isValid = value.unicodeScalars.allSatisfy{allowedChars.contains($0)}
        return isValid
    }
}
