import Foundation

actor LocationClient {
    private let characterCache: NSCache<NSString, CacheEntryObject> = NSCache()
    private let urlString = "https://rickandmortyapi.com/api"
    private lazy var decoder: JSONDecoder = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return aDecoder
    } ()
    private let downloader: any HTTPDataDownloader
    
    var locations: [Location] {
        get async throws {
            let data = try await downloader.httpData(from: URL(string: urlString + "/location")!)
            let allLocations = try decoder.decode(AllLocations.self, from: data)
            let locations = allLocations.locations
            var updatedLocations = locations
            updatedLocations[0].selected = true
            try await withThrowingTaskGroup(of: [Character].self) { group in
                group.addTask {
                    let characters = try await self.characters(location: locations[0])
                    return characters
                }
                while let result = await group.nextResult() {
                    switch result {
                    case .failure(let error):
                        throw error
                    case .success(let characters):
                        updatedLocations[0].residents = characters
                    }
                }
            }
            return updatedLocations
        }
    }
    
    init(downloader: any HTTPDataDownloader = URLSession.shared) {
        self.downloader = downloader
    }
    
    func characters(location: Location) async throws -> [Character] {
        if let cached = characterCache[location.id] {
            switch cached {
            case .ready(let characters):
                return characters
            case .inProgress(let task):
                return try await task.value
            }
        }
        let task = Task<[Character], Error> {
            var characterIdList: [String] = []
            for characterUrl in location.residentsUrl {
                let characterId = characterUrl.dropFirst(42)
                characterIdList.append(String(characterId))
            }
            if characterIdList.count == 1 {
                let url = URL(string: urlString + "/character/" + "\(characterIdList[0])")!
                let data = try await downloader.httpData(from: url)
                let character = try decoder.decode(Character.self, from: data)
                let singleCharacter: [Character] = [character]
                return singleCharacter
            }
            if characterIdList.count == 0 {
                return []
            }
            let strOfIds = characterIdList.joined(separator: ",")
            let url = URL(string: urlString + "/character/" + strOfIds)!
            let data = try await downloader.httpData(from: url)
            let allCharacters = try decoder.decode(AllCharacters.self, from: data)
            let characters = allCharacters.characters
            return characters
        }
        characterCache[location.id] = .inProgress(task)
        do {
            let characters = try await task.value
            return characters
        } catch {
            characterCache[location.id] = nil
            throw error
        }
    }
    
    func fetchNextPage(pageIndex: Int) async throws -> [Location] {
        let url = URL(string: urlString + "/location?page=\(pageIndex)")!
        let data = try await downloader.httpData(from: url)
        let allLocations = try decoder.decode(AllLocations.self, from: data)
        return allLocations.locations
    }
}
