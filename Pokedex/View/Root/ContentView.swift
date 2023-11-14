//
//  ContentView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 12/11/2566 BE.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var pokemonViewModel: PokemonViewModel

    var body: some View {
        Group{
            if authViewModel.userSession != nil{
                TabView{
                    PokedexView().tabItem {
                        Image(systemName: "pawprint.fill")
                        Text("Pokedex")
                    }.tint(Color(red: 0.957, green: 0.455, blue: 0.455))
                        
                    
                    MyPokemonView().tabItem {
                        
                        Image(systemName: "heart.text.square")
                        Text("My Pokemon")
                    }.tint(Color(red: 0.957, green: 0.455, blue: 0.455))
                    
                    ProfileView().tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }.tint(.white)
                }
                .tint(Color(red: 0.957, green: 0.455, blue: 0.455))
                .environmentObject(authViewModel)
                .environmentObject(pokemonViewModel)
                    
                    
            }else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AuthViewModel())
}
