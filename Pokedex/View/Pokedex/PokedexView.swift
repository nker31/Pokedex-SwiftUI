//
//  PokedexView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 13/11/2566 BE.
//

import SwiftUI

struct PokedexView: View {
    @EnvironmentObject var pokemonViewModel: PokemonViewModel
    @EnvironmentObject var myPokemonViewModel: MyPokemonViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var pokemonData: [Pokemon]? = nil
    @State private var isDisplayTwoColums: Bool = true
    @State private var isFetching: Bool = true

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
            
            ZStack {
                // display progress view when fetching data
                if(isFetching){
                    PokeballProgressView().task {
                        do {
                            pokemonData = try await pokemonViewModel.fetchPokemon()
                            sleep(UInt32(3.0))
                            print("Fetched Pokemon")
                            print(pokemonData![0])
                        } catch {
                            // Handle the error here
                            print("Error fetching pokemon: \(error)")
                            
                        }
                        isFetching = false
                    }
                }
                ScrollView{
                    Spacer().frame(height: 15)
                    if(isFetching){
 
                    }
                    // display pokemon data collection
                    else if let pokemonData = pokemonData{
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
                    }else{
                        VStack{
                            
                            Image("pikachu-curious")
                                .resizable()
                                .frame(width: 150, height: 150)
                            Text("Opps").bold()
                            Text("Failed to fetching data").font(.subheadline)
                        }.padding(50)
                    }
                    
                }
                .refreshable {
                    isFetching.toggle()
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
                                        SearchView().environmentObject(pokemonViewModel)
                                    }, label: {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundStyle(Color(red: 0.957, green: 0.455, blue: 0.455))
                                    })
                                }
                            }
            )
            }
        }
    }
}

#Preview {
    PokedexView().environmentObject(PokemonViewModel())
}
