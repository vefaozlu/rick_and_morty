import Foundation

struct Location: Identifiable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residentsUrl: [String]
    let url: URL
    let created: Date
    var residents: [Character] = []
    var selected: Bool = false
}

extension Location: Decodable {
    private enum LocationCodingKeys: String, CodingKey {
        case id
        case name
        case type
        case dimension
        case residents
        case url
        case created
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: LocationCodingKeys.self)
        let rawId = try? values.decode(Int.self, forKey: .id)
        let rawName = try? values.decode(String.self, forKey: .name)
        let rawType = try? values.decode(String.self, forKey: .type)
        let rawDimension = try? values.decode(String.self, forKey: .dimension)
        let rawResidentsUrl = try? values.decode([String].self, forKey: .residents)
        let rawUrl = try? values.decode(URL.self, forKey: .url)
        let rawCreated = try? values.decode(Date.self, forKey: .created)
        
        guard let id = rawId,
              let name = rawName,
              let type = rawType,
              let dimension = rawDimension,
              let residentsUrl = rawResidentsUrl,
              let url = rawUrl,
              let created = rawCreated
        else {
            throw CharacterError.missingData
        }
        
        self.id = id
        self.name = name
        self.type = type
        self.dimension = dimension
        self.residentsUrl = residentsUrl
        self.url = url
        self.created = created
        self.residents = []
    }
}

struct AllLocations: Decodable {
    private enum RootKeys: String, CodingKey {
        case results
    }
    
    private(set) var locations: [Location] = []
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        var resultsContainer = try rootContainer.nestedUnkeyedContainer(forKey: .results)
        
        while !resultsContainer.isAtEnd {
            let location = try resultsContainer.decode(Location.self)
            self.locations.append(location)
        }
    }
}
