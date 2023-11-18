//
//  PokeballProgressView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 18/11/2566 BE.
//

import SwiftUI

struct PokeballProgressView: View {
    @State private var isRotating = 0.0
    var body: some View {
        ZStack{
            // transparent bg
            Rectangle().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).opacity(0.5).ignoresSafeArea()
            VStack{
                Image("pokeball")
                    .resizable()
                    .frame(width: 80,height: 80)
                    .rotationEffect(.degrees(isRotating))
                    .onAppear {
                        withAnimation(.linear(duration: 1)
                            .speed(0.5).repeatForever(autoreverses: false)) {
                                isRotating = 360.0
                            }
                        
                    }
                Text("Loading")
                    .foregroundStyle(.white)
                    .bold()
            }
        }
    }
}

#Preview {
    PokeballProgressView()
}
