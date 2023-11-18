//
//  EditProfileView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 13/11/2566 BE.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @State private var firstName = ""
    @State private var lastname = ""
    
    @State private var selectedPhotoData:Image?
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var profileImageData: Data? = nil
    
    @State private var isAlert = false
    @State private var isloading = false
    
    @StateObject var authViewModel: AuthViewModel
    var body: some View {
        
        ZStack {
            
            VStack{
                
                VStack{

                    ZStack(alignment: .bottomTrailing){
                        if let selectedPhotoData{
                            selectedPhotoData
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 130)
                                .cornerRadius(64)
                        }else{
                            AsyncImage(url: authViewModel.profileImageData) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 130, height: 130)
                                    .cornerRadius(64)
                            } placeholder: {
                                Image("pokeball-profile")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130, height: 130)
                                    .cornerRadius(64)
                            }
                        }
                        PhotosPicker(
                                selection: $selectedPhoto,
                                matching: .images,
                                photoLibrary: .shared()) {
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.black)
                                    
                                }.frame(width: 30, height: 30)
                            .background(.gray)
                            .cornerRadius(20)
                    }
                    .onChange(of: selectedPhoto, initial: true) { oldItem, newItem in
                        Task {
                            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    selectedPhotoData = Image(uiImage: uiImage)
                                    profileImageData = uiImage.jpegData(compressionQuality: 0.5)
                                    return
                                }
                            }

                            print("Failed")
                        }
                      
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .background(Color(red: 0.957, green: 0.455, blue: 0.455))
                
                VStack{
                    VStack(spacing: 20){
                        InputView(text: $firstName, title: "First Name", placeholder: "firstname")
                        InputView(text: $lastname, title: "Last Name", placeholder: "lastname")
                    }.padding(.horizontal, 25)
                        .padding(.vertical, 30)
                    
                    // Register
                    Button(action: {
                        Task{
                            isloading = true
                            try await authViewModel.editUser(firstname:firstName,lastname:lastname, profileImageData: profileImageData)
                            isAlert = true
                            isloading = false
                        }
                        
                    }, label: {
                        Text("Update")
                            
                    })
                    .frame(width: UIScreen.main.bounds.width - 40, height: 40)
                    .background(Color(red: 0.957, green: 0.455, blue: 0.455))
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    
                    Spacer()
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }.background(Color(red: 0.957, green: 0.455, blue: 0.455).opacity(0.1))
                .alert("Update data successfully", isPresented: $isAlert) {
                            Button("OK", role: .cancel) { }
                        }
                
                .task {
                    firstName = authViewModel.currentUser?.firstname ?? "Firstname"
                    lastname = authViewModel.currentUser?.lastname ?? "Lastname"
            }
            if(isloading){
                PokeballProgressView()
            }
        }
        
    }
}

#Preview {
    EditProfileView(authViewModel: AuthViewModel())
}
