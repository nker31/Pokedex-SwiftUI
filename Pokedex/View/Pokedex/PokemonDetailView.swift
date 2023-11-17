//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 14/11/2566 BE.
//

import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject var pokemonViewModel: PokemonViewModel
    @EnvironmentObject var myPokemonViewModel: MyPokemonViewModel
    @State var pokemon:Pokemon
    @State var isLike = false
    var body: some View {
        VStack{
//           Start Pokemon pic box
            VStack{
                // Pokemon name
                Text("\(pokemon.name)")
                    .font(.system(size: 32))
                    .bold()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 25)
                
                Spacer().frame(height: 60)
                
                // Pokemon pic
                AsyncImage(url: pokemon.imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                } placeholder: {
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
            .background(LinearGradient(gradient: Gradient(colors: [Color(pokemonViewModel.pokemonBGColor(type: pokemon.types[0])), .white]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .background()

            
//            Pokemon Pic box
            
            // Scroll View
            ScrollView{
                // Pokemon description
                VStack{
                    Text("\(pokemon.xDescription)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(20)
                }
                // Pokemon type row
                HStack(spacing: 10){
                    ForEach(pokemon.types, id: \.self) { type in
                        Text("\(type)")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .frame(height: 30)
                            .background(Color(pokemonViewModel.pokemonBGColor(type: type)))
                            .cornerRadius(30)
                    }
                }
                // Pokemon height and weight
                HStack{
                    VStack(alignment: .leading, spacing: 10){
                        Text("Height")
                            .foregroundStyle(.secondary)
                            .font(.headline)
                        Text("\(pokemon.height)")
                            .font(.subheadline)
                    }
                    .padding(.vertical,12)
                    
                    Spacer().frame(width: 100)
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("Weight")
                            .foregroundStyle(.secondary)
                            .font(.headline)
                        Text("\(pokemon.weight)")
                            .font(.subheadline)
                    }
                    .padding(.vertical,12)
                    
                
                }
                .frame(maxWidth: .infinity)
                    .padding(20)
                
                
                // Pokemon Breeding
                Text("Breeding")
                    .foregroundStyle(Color(pokemonViewModel.pokemonBGColor(type: pokemon.types[0])))
                    .font(.headline)
                    
                VStack(spacing: 10){
                    // Gender
                    HStack{
                        Text("Gender")
                            .foregroundStyle(.secondary)
                            .font(.headline)
                            .frame(width: 90,alignment: .leading)
                            
                        HStack{
                            Text("♂").font(.title).foregroundStyle(.blue)
                            Text("\(pokemon.malePercentage ?? "N/A")").font(.subheadline)
                            Text("♀").font(.title).foregroundStyle(.pink)
                            Text("\(pokemon.femalePercentage ?? "N/A")").font(.subheadline)
                        }
                        Spacer()
                        
                    }
                    HStack{
                        Text("Egg grops")
                            .foregroundStyle(.secondary)
                            .font(.headline)
                            .frame(width: 90,alignment: .leading)
                        Text("\(pokemon.eggGroups)")
                            .font(.subheadline)
                        Spacer()
                    }
                    HStack{
                        Text("Egg Cycle")
                            .foregroundStyle(.secondary)
                            .font(.headline)
                            .frame(width: 90,alignment: .leading)
                        Text("\(pokemon.cycles)")
                        
                        Spacer()
                    }
                }.padding(.horizontal,20)
                
            
                
                // Pokemon location
                

                    
                // Training
            }
            
            Spacer()
            
        }
        .task {
            if(myPokemonViewModel.myPokemonIDs.contains(pokemon.id)){
                isLike = true
            }else{
                isLike = false
            }
        }
        .toolbar(content: {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                Task{
                                    await myPokemonViewModel.addPokemon(pokemonID: pokemon.id )
                                    if(myPokemonViewModel.myPokemonIDs.contains(pokemon.id)){
                                        isLike = true
                                    }else{
                                        isLike = false
                                    }
                                }
                                
                                
                            }, label: {
                                Image(systemName: isLike ? "heart.fill": "heart")
                            })
                        }
                    }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

#Preview {
    NavigationStack{
        PokemonDetailView(pokemon: MOCK_POKEMON[0]).environmentObject(PokemonViewModel())
    }
}
