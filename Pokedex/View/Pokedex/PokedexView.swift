//
//  PokedexView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 13/11/2566 BE.
//

import SwiftUI

struct PokedexView: View {
    @EnvironmentObject var pokemonViewModel: PokemonViewModel
    @State private var pokemonData: [Pokemon]? = nil
    @State private var isDisplayTwoColums: Bool = true

    let twoColumns = [
            GridItem(.fixed(170), spacing: 15),
            GridItem(.fixed(170), spacing: 15)
            
        ]
    
    let threeColumns = [
        GridItem(.fixed(100), spacing: 20),
        GridItem(.fixed(100), spacing: 20),
        GridItem(.fixed(100), spacing: 20)
    ]
    var body: some View {
        NavigationStack{
            if let pokemonData = pokemonData{
                ScrollView{
                    Spacer().frame(height: 15)
                    LazyVGrid(columns: isDisplayTwoColums ? twoColumns: threeColumns, spacing: 15,content: {
                        ForEach(pokemonData, id: \.name) { pokemon in
                            
                            if(isDisplayTwoColums){
                                PokemonComponent(pokemon: pokemon).environmentObject(pokemonViewModel)
                            }
                            else{
                                // display grid 3 colums
                                PokemonImageComponent(pokemon: pokemon).environmentObject(pokemonViewModel)
                            }
                        }
                    })
                }
                .frame(maxWidth: .infinity, maxHeight:.infinity)

                .navigationTitle("Pokedex").navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button(action: {
                                        isDisplayTwoColums.toggle()
                                    }, label: {
                                        Image(systemName: isDisplayTwoColums ? "square.grid.3x3" : "rectangle.grid.2x2" )
                                            .foregroundStyle(Color(red: 0.957, green: 0.455, blue: 0.455))
                                    })
                                    
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    NavigationLink(destination: {
                                        SearchView()
                                    }, label: {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundStyle(Color(red: 0.957, green: 0.455, blue: 0.455))
                                    })
                                }
                            }
                )
            }
            
            else{
                ProgressView().task {
                    do {
                        pokemonData = try await pokemonViewModel.fetchPokemon()
                        print("Fetched Pokemon")
                        print(pokemonData![0])
                    } catch {
                        // Handle the error here
                        print("Error fetching pokemon: \(error)")
                    }
                }
            }
            
            
            
            
            
            
        }
        
        

    }
}

#Preview {
    PokedexView().environmentObject(PokemonViewModel())
}
