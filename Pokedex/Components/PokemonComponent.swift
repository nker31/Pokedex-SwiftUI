//
//  PokemonComponent.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 13/11/2566 BE.
// "https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png"

import SwiftUI

struct PokemonComponent: View {
    @EnvironmentObject var pokemonViewModel: PokemonViewModel
    @State var pokemon: Pokemon
    var body: some View {
        NavigationLink(destination: {
            PokemonDetailView(pokemon: pokemon)
        }, label: {
            ZStack{
                VStack(alignment: .leading){
                    Text("\(pokemon.name.capitalized)")
                        .font(.system(size: 24))
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.top, 5)

                    HStack(alignment: .bottom){
                        VStack (alignment: .leading, spacing: 15){
                            
                            ForEach(pokemon.types, id: \.self) { type in
                                Text(type)
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.white.opacity(0.3))
                                            .frame(height: 25)
                                    )
                                        }
                                
                            
                            
                            
                                                
                            Spacer()
                        }
    //                    .border(Color.black)
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
    //                .border(.black)
                        .frame(height: 100)
                }
                .padding(.horizontal, 10)
                
                
                
                
            }
            .frame(width: 170, height: 170)
            .background(Color(pokemonViewModel.pokemonBGColor(type: pokemon.types[0])))
                .cornerRadius(15)
        })

        
    }
}

#Preview {
    PokemonComponent(pokemon: MOCK_POKEMON[0]).environmentObject(PokemonViewModel())
}
