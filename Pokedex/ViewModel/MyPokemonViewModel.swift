//
//  MyPokemonViewModel.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 16/11/2566 BE.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class MyPokemonViewModel: ObservableObject{
    var myPokemonIDs:[String] = []
    var currentUserID: String = ""
    
    
    func fetchMyPokemon(userID: String) async{
        let db = Firestore.firestore()
        
        do{
            let documentSnapshot = try await  db.collection("pokemons").document(userID).getDocument()
            
            if documentSnapshot.exists{
                // fetch pokemon id array
                let data = documentSnapshot.data()
                // assign fetced array to view model array
                myPokemonIDs = data?["favPokemon"] as? [String] ?? ["nothing here"]
            }else{
                // if document is not exist then create new document from userID
                try await db.collection("pokemons").document(userID).setData(["favPokemon": []])
            }
            print("Fetching data successfully")
        }catch{
            
        }
        
    }
    
    func getMyPokemonArray(userID: String) async -> [String]{
        currentUserID = userID
        await fetchMyPokemon(userID: userID)
        return myPokemonIDs // return array of pokemon id
    }

    
    func addPokemon(pokemonID: String) async{
        let db = Firestore.firestore()
        let dbRef = db.collection("pokemons").document(currentUserID)
        print("User ID: \(currentUserID)")
        
        // if pokemon id is exist then delete from array
        if(myPokemonIDs.contains(pokemonID)){
            
            if let targetIndex = myPokemonIDs.firstIndex(of: pokemonID){
                
                myPokemonIDs.remove(at: targetIndex)
                print("removed \(pokemonID) already")
                print("my pokemon array after remove: \(myPokemonIDs)")
            }
            
        }else{ // insert selected pokemon id to array
            
            myPokemonIDs.append(pokemonID)
                print("my pokemon array after add: \(myPokemonIDs)")

        }
        
        do {
            // update firebase data 
            try await dbRef.updateData([
                "favPokemon": myPokemonIDs
            ])
            print("Document successfully updated")

            // Fetch updated pokemon list
            await fetchMyPokemon(userID: currentUserID)
        } catch {
            print("Error updating document: \(error)")
        }
        
    }
    
    
}
