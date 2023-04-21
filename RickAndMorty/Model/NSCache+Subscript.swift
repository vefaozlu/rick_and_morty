import Foundation

extension NSCache where KeyType == NSString, ObjectType == CacheEntryObject {
    subscript(_ id: Int) -> CacheEntry? {
        get {
            let key = String(id) as NSString
            let value = object(forKey: key)
            return value?.entry
        }
        set {
            let key = String(id) as NSString
            if let entry = newValue {
                let value = CacheEntryObject(entry: entry)
                setObject(value, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}
