//
//  PokemonImageComponent.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 15/11/2566 BE.
//

import SwiftUI

struct PokemonImageComponent: View {
    @EnvironmentObject var pokemonViewModel: PokemonViewModel
    @State var pokemon: Pokemon

    var body: some View {
        NavigationLink(destination: {
            PokemonDetailView(pokemon: pokemon)
        }, label: {
            ZStack{
                AsyncImage(url: pokemon.imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 70)
                        .padding([.bottom,.trailing],3)
                } placeholder: {
                    Image("pokeball")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 70)
                        .cornerRadius(64)
                        .padding([.bottom,.trailing ],3)
                }

            }
            .frame(width: 110, height: 110)
            .background(Color(pokemonViewModel.pokemonBGColor(type: pokemon.types[0])))
            .cornerRadius(10)
        })
    }
}

#Preview {
    PokemonImageComponent(pokemon: MOCK_POKEMON[0]).environmentObject(PokemonViewModel())
}
