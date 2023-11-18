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
    @StateObject var myPokemonViewModel = MyPokemonViewModel()
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView().environmentObject(authViewModel)
                .environmentObject(pokemonViewModel)
                .environmentObject(myPokemonViewModel)
        }
    }
}
