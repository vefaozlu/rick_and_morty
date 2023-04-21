import Foundation

extension Character {
    static var preview: Character {
        let character = Character(id: 0,
                                  name: "Rick",
                                  status: "Alive",
                                  species: "Human",
                                  gender: "Male",
                                  origin: CharacterLocation(name: "Earth (C-137)", url: nil),
                                  location: CharacterLocation(name: "Citadel of Ricks", url: nil),
                                  imgLink: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!,
                                  episode: "1, 2, 3, 4, 5",
                                  created: Date(timeIntervalSinceNow: -10000))
        return character
    }
}
