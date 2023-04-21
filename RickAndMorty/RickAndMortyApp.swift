//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Vefa Ozlu on 4/15/23.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    @StateObject var locationsProvider = LocationsProvider()
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(locationsProvider)
        }
    }
}
