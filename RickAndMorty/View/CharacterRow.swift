import SwiftUI

struct CharacterRow: View {
    let character: Character
    var body: some View {
        HStack {
            AsyncImage(url: character.imgLink) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                } else if phase.error != nil {
                    Image(systemName: "exclamationmark.icloud")
                        .padding(40)
                } else {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            }
            Text(character.name)
            Spacer()
            Image(character.gender)
                .resizable()
                .scaledToFit() 
                .frame(width: 60, height: 60)
        }
        .frame(height: 100)
    }
}
