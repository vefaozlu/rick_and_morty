import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .opacity,
            removal: .opacity)
    }
}

struct SplashScreen: View {
    @EnvironmentObject var locationsProvider: LocationsProvider
    
    @AppStorage("firtLaunched")
    var firstLaunched = true
    
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if isActive {
                Locations()
                    .environmentObject(locationsProvider)

            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                    VStack {
                        Image("rick_and_morty")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                        Text(firstLaunched ? "Welcome!" : "Hello!")
                            .font(.title)
                    }
                }
                //.transition(.move(edge: .bottom))
                .transition(.opacity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation (.easeOut(duration: 1)) {
                            self.isActive = true
                        }
                    }
                }
                .onDisappear {
                    firstLaunched = false
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
            .environmentObject(LocationsProvider(client: LocationClient()))
    }
}
