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
    
    @StateObject var authViewModel: AuthViewModel
    var body: some View {
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
                            Circle().frame(width: 130, height: 130)
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
                                profileImageData = uiImage.jpegData(compressionQuality: 0.75)
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
                        try await authViewModel.editUser(firstname:firstName,lastname:lastname, profileImageData: profileImageData)
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
            
            .task {
                firstName = authViewModel.currentUser?.firstname ?? "Firstname"
                lastname = authViewModel.currentUser?.lastname ?? "Lastname"
            }
        
    }
}

#Preview {
    EditProfileView(authViewModel: AuthViewModel())
}
