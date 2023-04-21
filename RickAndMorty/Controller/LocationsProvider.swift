import Foundation

@MainActor
class LocationsProvider: ObservableObject {
    
    @Published var locations: [Location] = []
    @Published var characters: [Character] = []
    private var locationPage = 1
    
    private let client: LocationClient
    
    func fetchLocations() async throws {
        let locations = try await client.locations
        self.locations = locations
        self.characters = locations[0].residents
        self.locations.append(Location.loadingItem)
    }
    
    func changeLocation(for location: Location) async throws {
        if let selectedIndex = self.locations.firstIndex(where: {$0.selected}) {
            self.locations[selectedIndex].residents = []
            self.locations[selectedIndex].selected = false
        }
        if let selectedIndex = self.locations.firstIndex(where: {$0.id == location.id}) {
            self.locations[selectedIndex].residents = try await client.characters(location: location)
            self.locations[selectedIndex].selected = true
            self.characters = locations[selectedIndex].residents
        }
    }
    
    func nextPage() async throws{
        locationPage += 1
        if locationPage > 7 {
            self.locations.remove(at: self.locations.count - 1)
            return
        }
        try await Task.sleep(nanoseconds: UInt64(2000000000))
        let locations: [Location] = try await client.fetchNextPage(pageIndex: locationPage)
        self.locations.remove(at: self.locations.count - 1)
        self.locations = self.locations + locations
        self.locations.append(Location.loadingItem)
    }
    
    init(client: LocationClient = LocationClient()) {
        self.client = client
    }
}
