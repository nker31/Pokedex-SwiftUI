//
//  SearchView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 13/11/2566 BE.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @EnvironmentObject var pokemonViewModel: PokemonViewModel
    @State private var pokemonData: [Pokemon]? = nil
    
    let twoColumns = [
            GridItem(.fixed(170), spacing: 15),
            GridItem(.fixed(170), spacing: 15)
            
        ]
    
    var body: some View {
        ScrollView{
            // display nothing
            if(searchText.isEmpty){
                
            }
            // searched pokemon not found
            else if(filteredPokemon.isEmpty){
                VStack{
                    Image("pikachu-back")
                        .resizable()
                        .scaledToFill()
                        .frame(width:230, height: 120)
                    Text("No result for ")
                        .font(.title2)
                    Text("\" \(searchText) \"")
                        .frame(width: 200)
                        .font(.title3)
                }.frame(width: 300, height: 300)
                    .padding(.vertical, 100)
                
            }
            // display searched pokemon
            else{
                LazyVGrid(columns: twoColumns, spacing: 15,content: {
                    ForEach(filteredPokemon){ pokemon in
                        PokemonComponent(pokemon: pokemon)
                        
                    }
                })
            }
        }
        .searchable(text: $searchText, prompt: "Please enter pokemon name")
        .task{
            do{
                pokemonData = try await pokemonViewModel.fetchPokemon()
            }catch{
                print("Failed to fetching data with error: \(error)")
            }
        }
    }
}

extension SearchView{
    var filteredPokemon: [Pokemon]{
        if searchText.isEmpty{
            return []
        }else{
            return pokemonData?.filter { $0.name.starts(with: searchText)} ?? []
        }
    }
}

#Preview {
    NavigationStack{
        SearchView().environmentObject(PokemonViewModel())
    }

}
