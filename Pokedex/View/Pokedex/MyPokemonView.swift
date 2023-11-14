//
//  MyPokemonView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 13/11/2566 BE.
//

import SwiftUI

struct MyPokemonView: View {
    var body: some View {
        NavigationStack{
            
            ScrollView{
                
            }
            .frame(maxWidth: .infinity, maxHeight:.infinity)

            .navigationTitle("My Pokemons").navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    print("Gallary Clicked")
                                }, label: {
                                    Image(systemName: "rectangle.grid.2x2")
                                })
                                
                            }
                            
                        }
            )
        }
    }
}

#Preview {
    MyPokemonView()
}
