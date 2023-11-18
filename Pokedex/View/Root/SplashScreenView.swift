//
//  SplashScreenView.swift
//  Splash
//
//  Created by Nathat Kuanthanom on 18/11/2566 BE.
//
import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var pokemonViewModel: PokemonViewModel
    @EnvironmentObject var myPokemonViewModel: MyPokemonViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var isActive = false
    @State var size = 1.0
    @State var opacity = 1.0

    var body: some View {
        if isActive {
            ContentView().environmentObject(authViewModel)
                .environmentObject(pokemonViewModel)
                .environmentObject(myPokemonViewModel)
        } else {
            VStack {
                VStack {
                    Image("pokeball-logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.5)) {
                        size = 0.6
                        opacity = 1
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        withAnimation(.easeOut(duration: 1)) {
                            size = 10.0
                            opacity = 0.2
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.957, green: 0.455, blue: 0.455))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(AuthViewModel())
        .environmentObject(MyPokemonViewModel())
        .environmentObject(PokemonViewModel())
}

