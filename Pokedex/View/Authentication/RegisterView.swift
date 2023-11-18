//
//  RegisterView.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 12/11/2566 BE.
//

import SwiftUI
import PhotosUI
import swiftui_loop_videoplayer

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var selectedPhotoData:Image?
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var profileImageData: Data? = nil
    
    @State var displayAlert = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        ZStack{
            
            LoopPlayerView{
                 Settings{
                     FileName("auth-video-bg")
                     Ext("mp4")
                     Gravity(.resizeAspectFill)
                     EFontSize(27)
                 }
            }.ignoresSafeArea()
            
            VStack{
                // image
                ZStack(alignment: .bottomTrailing){
                    if let selectedPhotoData{
                        selectedPhotoData
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(64)
                    }else{
                        Image("pokeball-profile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(64)
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
                
                // form
                VStack(spacing: 10){
                    InputView(text: $email, title: "Email", placeholder: "email")
                        .autocapitalization(.none)
                    
                    InputView(text: $password, title: "Password", placeholder: "password", isSecureField: true)
                    
                    InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "confirm password", isSecureField: true)
                    
                    InputView(text: $firstname, title: "First Name", placeholder: "first name")
                    
                    InputView(text: $lastname, title: "Last Name", placeholder: "last name")
                    
                }
                .foregroundStyle(.white)
                .bold()
                .padding(.horizontal, 20)
                
                
                // Register
                Button(action: {
                    
                    Task{
                        if let profileImage = profileImageData{
                            // force unwrap caution
                            try await authViewModel.createUser(withEmail: email, password: password, firstname: firstname, lastname: lastname, profileImageData: profileImageData!)
                        }else{
                            displayAlert.toggle()
                        }
                    }
                }, label: {
                    Text("Register")
                        
                })
                .frame(width: UIScreen.main.bounds.width - 40, height: 40)
                .background(Color(red: 0.957, green: 0.455, blue: 0.455))
                .foregroundColor(.white)
                .cornerRadius(30)
                .padding(.top, 30)
                .disabled(!formValid)
                .opacity(formValid ? 1.0: 0.5)
            }
        }.alert("Please upload your profile image", isPresented: $displayAlert) {
            Button("OK", role: .cancel) { }
        }
        
    }
}

// MARK: - AuthenticationFormProtocal
extension RegisterView: AuthenticationFormProtocal{
    var formValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count >= 8
        && password == confirmPassword
        && !firstname.isEmpty
        && !lastname.isEmpty
    }
}

#Preview {
    RegisterView()
}
