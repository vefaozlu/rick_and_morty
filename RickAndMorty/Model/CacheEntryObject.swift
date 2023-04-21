import Foundation

final class CacheEntryObject {
    let entry: CacheEntry
    init(entry: CacheEntry) {self.entry = entry}
}

enum CacheEntry {
    case inProgress(Task<[Character], Error>)
    case ready([Character])
}
