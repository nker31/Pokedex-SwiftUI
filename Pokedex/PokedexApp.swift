//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 12/11/2566 BE.
//

import SwiftUI
import FirebaseCore


@main
struct PokedexApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var pokemonViewModel = PokemonViewModel()
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authViewModel)
                .environmentObject(pokemonViewModel)
        }
    }
}
