import SwiftUI

struct CharacterDetail: View {
    let character: Character
    let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        ScrollView {
            AsyncImage(url: character.imgLink) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .frame(width: 275, height: 275)
                } else if phase.error != nil {
                    Image(systemName: "exclamationmark.icloud")
                        .frame(width: 275, height: 275)
                } else {
                    ProgressView()
                        .frame(width: 275, height: 275)
                }
            }
            .padding([.vertical], 20)
            .padding([.horizontal], 50)
            
            VStack(alignment: .trailing, spacing: 20) {
                InfoRow(title: "Status:", text: character.status)
                InfoRow(title: "Species:", text: character.species)
                InfoRow(title: "Gender:", text: character.gender)
                InfoRow(title: "Origin:", text: character.origin.name ?? "unknown")
                InfoRow(title: "Location:", text: character.location.name ?? "unknown")
                InfoRow(title: "Episodes:", text: character.episode)
                InfoRow(title: "Created:", text: "\(character.created)")
            }
            .padding([.bottom], 20)
        }
        .navigationBarTitle(character.name, displayMode: .inline)
    }
}

struct InfoRow: View {
    let title: String
    let text: String
    let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("Avenir", size: 22, relativeTo: .headline))
                .fontWeight(.bold)
                .padding([.horizontal], 20)
                .frame(width: screenSize.width * 0.4, alignment: .leading)
            Text(text)
                .font(.custom("Avenir", size: 22, relativeTo: .headline))
                .padding([.horizontal], 20)
                .frame(width: screenSize.width * 0.6, alignment: .leading)
        }
    }
}

struct CharacterDetail_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetail(character: Character.preview)
    }
}
