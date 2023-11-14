//
//  SearchView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 13/11/2566 BE.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    var body: some View {
        VStack{
         Text("\(searchText)")
        }
        .searchable(text: $searchText)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SearchView()
}
