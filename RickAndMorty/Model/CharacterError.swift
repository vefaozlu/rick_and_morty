import Foundation

enum CharacterError: Error {
    case missingData
    case networkError
    case unexpectedError(error: Error)
}

extension CharacterError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingData:
            return NSLocalizedString("Discarding a character missing a valid code.", comment: "")
        case .networkError:
            return NSLocalizedString("Error fetching character data over the network.", comment: "")
        case .unexpectedError(let error):
            return NSLocalizedString("Received unexpected error. \(error.localizedDescription)", comment: "")
        }
    }
}
