//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 14/11/2566 BE.
//

import SwiftUI
import MapKit

struct PokemonDetailView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 14.039671322379816, longitude: 100.61338854675614), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    
    // view model variables
    @EnvironmentObject var pokemonViewModel: PokemonViewModel
    @EnvironmentObject var myPokemonViewModel: MyPokemonViewModel
    
    // pokemon variables
    @State var pokemon:Pokemon
    @State private var pokemonData: [Pokemon]? = nil
    @State private var filteredPokemons: [Pokemon] = []
    
    
    // Display variables
    @State var isLike = false
    @State var isDisplayAbout = true
    @State var isDisplayStat = false
    @State var isDisplayEvo = false
    @State var isLoading = true
    @State var isRotating = 0.0
    
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
                
                Spacer().frame(height: 40)
                
                // Pokemon pic
                ZStack(alignment: .bottom){
                    Image("pokeball-logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 210, height: 210)
                        .opacity(0.5)
                        .rotationEffect(.degrees(isRotating))
                        .onAppear {
                            withAnimation(.linear(duration: 5)
                                .speed(0.5).repeatForever(autoreverses: false)) {
                                    isRotating = 360.0
                                }
                            
                        }
                    
                    AsyncImage(url: pokemon.imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 180, height: 180)
                    } placeholder: {
                        Image("pokeball")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 180, height: 180)
                            .opacity(0.5)
                    }
                    
                    
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
            .background(LinearGradient(gradient: Gradient(colors: [Color(pokemonViewModel.pokemonBGColor(type: pokemon.types[0])), .white]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .background()

            
//            Pokemon Pic box
            // Tab bar
            HStack(spacing:50){
                Button(action: {
                    isDisplayAbout = true
                    isDisplayStat = false
                    isDisplayEvo = false
                }, label: {
                    TabMenu(title: "ABOUT", menuColor: Color(pokemonViewModel.pokemonBGColor(type: pokemon.types[0])), display: isDisplayAbout)
                })
                Button(action: {
                    isDisplayAbout = false
                    isDisplayStat = true
                    isDisplayEvo = false
                }, label: {
                    TabMenu(title: "STATS", menuColor: Color(pokemonViewModel.pokemonBGColor(type: pokemon.types[0])), display: isDisplayStat)
                })
                Button(action: {
                    isDisplayAbout = false
                    isDisplayStat = false
                    isDisplayEvo = true
                }, label: {
                    TabMenu(title: "EVOLUTIONS", menuColor: Color(pokemonViewModel.pokemonBGColor(type: pokemon.types[0])), display: isDisplayEvo)

                })
            }
                .frame(maxWidth: .infinity, maxHeight: 40)
            Divider()
            
            // Scroll View
            ScrollView{
                if isDisplayAbout{
                    
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
                            .padding(.bottom, 20)
                        
                    
                        
                        // Pokemon location
                        Text("Location")
                            .foregroundStyle(Color(pokemonViewModel.pokemonBGColor(type: pokemon.types[0])))
                            .font(.headline)
                    

                        VStack {
                            Map(coordinateRegion: $region)
                                .mapStyle(.standard)
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 150)
                        .padding(.horizontal,20)
                        .padding(.bottom, 20)
                        .cornerRadius(20)
                            
                            
                        // Training
                        Text("Training")
                            .foregroundStyle(Color(pokemonViewModel.pokemonBGColor(type: pokemon.types[0])))
                            .font(.headline)
                        VStack{
                            HStack{
                                Text("Base exp")
                                    .foregroundStyle(.secondary)
                                    .font(.headline)
                                    .frame(width: 90,alignment: .leading)
                                Text("\(pokemon.baseExp)")
                                    .font(.subheadline)
                                Spacer()
                            }
                        }
                        .padding(.horizontal,20)
                        .padding(.bottom, 20)
                    
                }else if (isDisplayStat){
                    // Stat
                    VStack{
                        PokemonStatRow(title: "HP", value: pokemon.hp, totalValue: 100)
                        PokemonStatRow(title: "Attack", value: pokemon.attack, totalValue: 100)
                        PokemonStatRow(title: "Defense", value: pokemon.defense, totalValue: 100)
                        PokemonStatRow(title: "Sp.ATK", value: pokemon.specialAttack ?? 0, totalValue: 100)
                        PokemonStatRow(title: "Sp.Def", value: pokemon.specialDefense ?? 0, totalValue: 100)
                        PokemonStatRow(title: "Speed", value: pokemon.speed, totalValue: 100)
                        PokemonStatRow(title: "Total", value: pokemon.total, totalValue: 600)
                        
                    }.tint(.red)
                    .padding(20)
                        
                    Text("Weaknesses")
                        .foregroundStyle(Color(pokemonViewModel.pokemonBGColor(type: pokemon.types[0])))
                        .font(.headline)
                    HStack(spacing: 10){
                        ForEach(pokemon.weaknesses, id: \.self) { type in
                            Text("\(type)")
                                .font(.subheadline)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .frame(height: 30)
                                .background(Color(pokemonViewModel.pokemonBGColor(type: type)))
                                .cornerRadius(30)
                        }
                    }
                    

                }else{
                    VStack{
                        if(!isLoading){
                            ForEach(0..<filteredPokemons.count-1){ index in
                                VStack{
                                    HStack{
                                        VStack{
                                            AsyncImage(url: filteredPokemons[index].imageUrl) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 80, height: 80)
                                                    .padding([.bottom,.trailing],3)
                                            } placeholder: {
                                                Image("pokeball")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 80, height: 80)
                                                    .cornerRadius(64)
                                                    .padding([.bottom,.trailing ],3)
                                            }
                                            Text(filteredPokemons[index].name)
                                                .foregroundStyle(.secondary)
                                                .font(.headline)
                                                .frame(width: 90,alignment: .leading)
                                        }
                                        
                                        Spacer()
                                        if(index > 0){
                                            Text("(Level 36)").font(.subheadline).foregroundStyle(.secondary)
                                        }else{
                                            Text("(Level 16)").font(.subheadline).foregroundStyle(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack{
                                            AsyncImage(url: filteredPokemons[index+1].imageUrl) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 80, height: 80)
                                                    .padding([.bottom,.trailing],3)
                                            } placeholder: {
                                                Image("pokeball")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 80, height: 80)
                                                    .cornerRadius(64)
                                                    .padding([.bottom,.trailing ],3)
                                            }
                                            Text(filteredPokemons[index+1].name)
                                                .foregroundStyle(.secondary)
                                                .font(.headline)
                                                .frame(width: 90,alignment: .leading)
                                        }
                                        
                                    }.frame(height: 140)
                                    .padding(.horizontal,20)
                                }
                                Divider()
                            }
                        }
                        else{
                            ProgressView()
                        }
                        
                                                
                    }.task {
                        do{
                            pokemonData = try await pokemonViewModel.fetchPokemon()
                            filteredPokemons = pokemonData?.filter { pokemon.evolutions.contains($0.id) } ?? []
                            isLoading = false
                            print("filtered pokemon: \(filteredPokemons)")
                            print("filtered pokemon length: \(filteredPokemons.count)")
                        }catch{
                            
                        }
                    }

                }
                
                Spacer()
            }
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
                                    .foregroundColor(.white)
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
        PokemonDetailView(pokemon: MOCK_POKEMON[0])
            .environmentObject(PokemonViewModel())
            .environmentObject(MyPokemonViewModel())
    }
}

struct PokemonStatRow: View {
    @State var title: String
    @State var value: Int
    @State var totalValue: Int
    var body: some View {
        HStack{
            Text("\(title)")
                .foregroundStyle(.secondary)
                .font(.headline)
                .frame(width: 80,alignment: .leading)
            
            Text("\(value)")
                .font(.subheadline)
                .frame(width: 30,alignment: .leading)
                .padding(.trailing, 5)
                
            ProgressView(value: Float(value), total: Float(totalValue))
                .foregroundColor(.red)
            Spacer()
        }
    }
}

struct TabMenu: View {
    var title: String
    var menuColor: Color
    var display: Bool
    var body: some View {
        Text(title)
            .font(.subheadline)
            .padding(.horizontal, 10)
            .frame(height: 30)
            .foregroundStyle(display ? .white : menuColor)
            .background(display ? menuColor: .white)
            .cornerRadius(8)
    }
}
