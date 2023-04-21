import Foundation

struct Character: Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: CharacterLocation
    let location: CharacterLocation
    let imgLink: URL
    var episode: String
    let created: Date
    
    struct CharacterLocation {
        let name: String?
        let url: URL?
    }
}

extension Character: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case gender
        case origin
        case location
        case image
        case episode
        case created
    }
    
    private enum LocationKeys: String, CodingKey {
        case name
        case url
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawId = try? values.decode(Int.self, forKey: .id)
        let rawName = try? values.decode(String.self, forKey: .name)
        let rawStatus = try? values.decode(String.self, forKey: .status)
        let rawSpecies = try? values.decode(String.self, forKey: .species)
        let rawGender = try? values.decode(String.self, forKey: .gender)
        let rawEpisode = try? values.decode([String].self, forKey: .episode)
        let rawImgLink = try? values.decode(URL.self, forKey: .image)
        let rawCreated = try? values.decode(Date.self, forKey: .created)
        
        let locationValue = try values.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        let rawLocationName = try? locationValue.decode(String.self, forKey: .name)
        let rawLocationUrl = try? locationValue.decode(URL.self, forKey: .url)
        
        let originValue = try values.nestedContainer(keyedBy: LocationKeys.self, forKey: .origin)
        let rawOriginName = try? originValue.decode(String.self, forKey: .name)
        let rawOriginUrl = try? originValue.decode(URL.self, forKey: .url)
        
        guard let id = rawId,
              let name = rawName,
              let status = rawStatus,
              let species = rawSpecies,
              let gender = rawGender,
              let episode = rawEpisode,
              let imgLink = rawImgLink,
              let created = rawCreated
        else {
            throw CharacterError.missingData
        }
        
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.imgLink = imgLink
        self.created = created
        self.location = CharacterLocation(name: rawLocationName, url: rawLocationUrl)
        self.origin = CharacterLocation(name: rawOriginName, url: rawOriginUrl)
        
        var episodeList: [String] = []
        for str in episode {
            let episodeNum = str.dropFirst(40)
            episodeList.append(String(episodeNum))
        }
        self.episode = episodeList.joined(separator: ", ")
    }
}

struct AllCharacters: Decodable {
    private(set) var characters: [Character] = []
    
    init(from decoder: Decoder) throws {
        var values = try decoder.unkeyedContainer()
        
        while !values.isAtEnd {
            let character = try values.decode(Character.self)
            self.characters.append(character)
        }
    }
}

