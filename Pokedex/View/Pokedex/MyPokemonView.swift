//
//  MyPokemonView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 13/11/2566 BE.
//

import SwiftUI

struct MyPokemonView: View {
    @EnvironmentObject var myPokemonViewModel: MyPokemonViewModel
    @EnvironmentObject var pokemonViewModel: PokemonViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var pokemonData: [Pokemon]? = nil
    @State private var pokemonIDs:[String] = []
    @State private var filteredPokemons: [Pokemon] = []
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
            ScrollView{
                Spacer().frame(height: 15)
                LazyVGrid(columns: isDisplayTwoColums ? twoColumns: threeColumns , spacing: 15,content: {
                    ForEach(filteredPokemons) { pokemon in
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
            .task {
                do{
                    pokemonData = try await pokemonViewModel.fetchPokemon()
                    pokemonIDs = await myPokemonViewModel.getMyPokemonArray(userID: authViewModel.currentUser?.id ?? "")
                    filteredPokemons = pokemonData?.filter { pokemonIDs.contains($0.id) } ?? []
                    
                }catch{
                    print("Failed to fetch data in MyPokemonView")
                }
            }

            
            .frame(maxWidth: .infinity, maxHeight:.infinity)

            .navigationTitle("My Pokemons").navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    isDisplayTwoColums.toggle()
                                }, label: {
                                    Image(systemName: isDisplayTwoColums ? "square.grid.3x3" : "rectangle.grid.2x2" )
                                        .foregroundStyle(Color(red: 0.957, green: 0.455, blue: 0.455))
                                })
                                
                            }
                            
                        }
            )
        }
    }
}

#Preview {
    MyPokemonView().environmentObject(MyPokemonViewModel())
}
