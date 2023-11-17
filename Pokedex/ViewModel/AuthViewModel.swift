//
//  AuthViewModel.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 12/11/2566 BE.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

protocol AuthenticationFormProtocal{
    var formValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var profileImageData: URL?
    @Published var isLoading = false
    
    init(){
        self.userSession = Auth.auth().currentUser
    }
    
    func signIn(withEmail email:String, password: String) async throws{
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            
        } catch{
            print("Failed to login with error: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, firstname: String, lastname: String, profileImageData: Data) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, firstname: firstname, lastname: lastname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            let storageRef = Storage.storage().reference(withPath: "profile_images/\(user.id).jpg")
            storageRef.putData(profileImageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print(error)
                } else {
                    print("Upload succesfully")
                }
            }
            
            await fetchUser()
            
        } catch{
            print("Failed to create user \(error.localizedDescription)")
        }
    }
    
    func editUser(firstname: String, lastname: String, profileImageData: Data?) async throws {
        guard let uid = self.userSession?.uid else { return }
        
        // Create a reference to the user's document in Firestore.
        let userDocRef = Firestore.firestore().collection("users").document(uid)
        
        // Begin a batch to ensure atomic updates.
        let batch = Firestore.firestore().batch()
        
        // Update the user's first and last name.
        batch.updateData(["firstname": firstname, "lastname": lastname], forDocument: userDocRef)
        
        // Commit the batch update to Firestore.
        try await batch.commit()
        
        // If there is new profile image data, upload it.
        if let imageData = profileImageData {
            let storageRef = Storage.storage().reference(withPath: "profile_images/\(uid).jpg")
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                } else {
                    print("Successfully uploaded image.")
                    // After uploading, fetch the download URL and update Firestore user document.
                    Task {
                        await self.updateProfileImageUrl(storageRef: storageRef, userDocRef: userDocRef)
                    }
                }
            }
        }
        
        // Fetch the updated user data.
        await fetchUser()
    }
    
    private func updateProfileImageUrl(storageRef: StorageReference, userDocRef: DocumentReference) async {
        do {
            let downloadURL = try await storageRef.downloadURL()
            try await userDocRef.updateData(["profileImageUrl": downloadURL.absoluteString])
        } catch {
            print("Error updating profile image URL: \(error.localizedDescription)")
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil // wipes out user session and takes me to login screen
            self.currentUser = nil // wipes out current user
        }catch {
            print("Failed to sign out with error: \(error.localizedDescription)")
        }
        
    }
    
    func deleteAccount(){
        
    }
    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
        print("Current user: \(String(describing: self.currentUser))")
        
        // Fetch user profile image as URL using uid
        let storageRef = Storage.storage().reference(withPath: "profile_images/\(uid).jpg")
        storageRef.downloadURL { url, error in
            if let error = error {
                
                print("This fetching error:\(error)")
            } else if let url = url {

                print(url)
                self.profileImageData = url
            }
        }
        
    }
}
