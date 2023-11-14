//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 14/11/2566 BE.
//

import Foundation
import SwiftUI

class PokemonViewModel: ObservableObject{
    @Published var pokemon = [Pokemon]()
    let baseUrl = "https://raw.githubusercontent.com/wirunpong-j/PokedexAPIMock/master/pokemons.json"
    

    func fetchPokemon() async throws -> [Pokemon]{
        guard let url = URL(string: "https://raw.githubusercontent.com/wirunpong-j/PokedexAPIMock/master/pokemons.json") else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Error fetching pokemon data")}
        
        let pokemonData = try JSONDecoder().decode([Pokemon].self, from: data)
        
        return pokemonData
    }
    
    func pokemonBGColor(type: String) -> Color{
        switch type{
        case "Fire": return Color(red: 1, green: 0.616, blue: 0.333) // #ff9d55
        case "Water": return Color(red: 0.302, green: 0.565, blue: 0.839) // #4d90d6
        case "Grass": return Color(red: 0.392, green: 0.733, blue: 0.365) // #64bb5d
        case "Ground": return Color(red: 0.851, green: 0.467, blue: 0.275) // #d97746
        case "Electric": return Color(red: 0.945, green: 0.835, blue: 0.227) // #f1d53a
        case "Poison": return Color(red: 0.667, green: 0.42, blue: 0.784) // #aa6bc8
        case "Psychic": return Color(red: 0.973, green: 0.439, blue: 0.463) // #f87076
        case "Fighting": return Color(red: 0.812, green: 0.243, blue: 0.42) // #cf3e6b
        case "Ghost": return Color(red: 0.322, green: 0.412, blue: 0.678) // #5269ad
        case "Dragon": return Color(red: 0.031, green: 0.424, blue: 0.765) // #086cc3
        case "Fairy": return Color(red: 0.929, green: 0.565, blue: 0.902) // #ed90e6
        case "Flying": return Color(red: 0.557, green: 0.663, blue: 0.871) // #8ea9de
        case "Normal": return Color(red: 0.569, green: 0.6, blue: 0.639) // #9199a3
        case "Rock" : return Color(red: 0.773, green: 0.718, blue: 0.549) // #c5b78c
        case "Bug": return Color(red: 0.569, green: 0.753, blue: 0.176) // #91c02d
        case "Ice": return Color(red: 0.447, green: 0.808, blue: 0.745) // #72cebe
        case "Steel": return Color(red: 0.353, green: 0.557, blue: 0.627) // #5a8ea0
        default:
            return .gray
        }
    }
}
