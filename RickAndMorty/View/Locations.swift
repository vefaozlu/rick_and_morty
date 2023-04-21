import SwiftUI

struct Locations: View {
    @EnvironmentObject var provider: LocationsProvider
    @State var loading: Bool = true
    @State private var error: CharacterError?
    
    var body: some View {
        NavigationView {
            VStack {
                
                Image("rick_and_morty")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)

                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(provider.locations) { location in
                            if location.id == -1 {
                                ProgressView()
                                    .padding()
                                    .onAppear {
                                        Task {
                                            try await provider.nextPage()
                                        }
                                    }
                            } else {
                                Text(location.name)
                                    .padding(5)
                                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black))
                                    .background(location.selected ? .gray : .white)
                                    .onTapGesture {
                                        Task {
                                            loading = true
                                            try? await provider.changeLocation(for: location)
                                            loading = false
                                        }
                                    }
                            }
                        }
                    }
                    .padding()
                    .frame(height: 50)
                }
                
                List {
                    ForEach(provider.characters) { character in
                        NavigationLink(destination: CharacterDetail(character: character)) {
                            CharacterRow(character: character)
                        }
                    }
                }
                
            }
            .task {
                if provider.locations.count == 0 {
                    try? await provider.fetchLocations()
                    loading = false
                }
            }
        }
        .navigationTitle("Rick And Morty")
    }
}

struct Locations_Previews: PreviewProvider {
    static var previews: some View {
        Locations()
            .environmentObject(LocationsProvider(client: LocationClient()))
    }
}

