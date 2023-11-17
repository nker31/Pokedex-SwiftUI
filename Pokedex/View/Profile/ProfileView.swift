//
//  ProfileView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 12/11/2566 BE.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var myPokemonViewModel: MyPokemonViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isPresentWebView = false
    var body: some View {
        if let user = authViewModel.currentUser{
            NavigationStack{
                VStack{
                    Group{
                        VStack{
                            AsyncImage(url: authViewModel.profileImageData) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 130, height: 130)
                                    .cornerRadius(64)
                            } placeholder: {
                                ProgressView()
                            }
                                                
                            Text("\(authViewModel.currentUser?.firstname ?? "Firstname")")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.white)
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .background(Color(red: 0.957, green: 0.455, blue: 0.455))
                        
                                        
                    }
    //                Spacer().frame(height: 30)
                    List{
                        
                        NavigationLink(destination: {
                            EditProfileView(authViewModel: authViewModel)
                        }, label: {
                            
                            HStack{
                                Image(systemName: "pencil")
                                Text("Edit profile")
                            }.foregroundStyle(Color(red: 0.957, green: 0.455, blue: 0.455))
                        })
                        
                        Button(action: {
                            isPresentWebView = true
                        }, label: {
                            HStack{
                                Image(systemName: "chart.bar.doc.horizontal.fill")
                                Text("Terms and Conditions")
                            }
                            .foregroundStyle(Color(red: 0.957, green: 0.455, blue: 0.455))
                        })
                        .sheet(isPresented: $isPresentWebView) {
                            NavigationStack {
                                WebView(url: URL(string: "https://pokedex-nextzy.web.app")!)
                                    .ignoresSafeArea()
                                    .navigationTitle("Terms and Conditions")
                                    .navigationBarTitleDisplayMode(.inline)
                            }
                        }


                        
                    }
                    .frame(maxHeight: 100)
                    .listStyle(.plain)
                    .padding(.vertical, 20)
                        
                    
                    // Log out button
                    Button(action: {
                        // before sign out clear data in array of myPokemonViewModel
                        myPokemonViewModel.myPokemonIDs = []
                        authViewModel.signOut()
                    }, label: {
                        Text("Log out")
                    })
                    .frame(width: UIScreen.main.bounds.width - 40, height: 40)
                    .background(Color(red: 0.957, green: 0.455, blue: 0.455))
                    .foregroundColor(.white)
                    .cornerRadius(30)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.957, green: 0.455, blue: 0.455).opacity(0.1))
                .task {
                    await authViewModel.fetchUser()
                }
            }
        }
    }
}

#Preview {
    ProfileView().environmentObject(AuthViewModel())
}
