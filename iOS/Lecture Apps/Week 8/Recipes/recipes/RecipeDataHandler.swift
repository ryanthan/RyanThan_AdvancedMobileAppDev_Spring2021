//
//  RecipeDataHandler.swift
//  Recipes
//
//  Created by Aileen Pierce
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class RecipeDataHandler {
    let db = Firestore.firestore()
    
    var recipeData = [Recipe]()
    
    //property with a closure as its value
    //closure takes an array of Recipe as its parameter and Void as its return type
    var onDataUpdate: ((_ data: [Recipe]) -> Void)?
    
    func dbSetup(){
        db.collection("recipes")
            .addSnapshotListener {querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching snapshot results: \(error!)")
                    return
                }
                self.recipeData = documents.compactMap {document-> Recipe? in
                    return try? document.data(as: Recipe.self)
                }
                //passing the results to the onDataUpdate closure
                self.onDataUpdate?(self.recipeData)
            }
    }
    
    func addRecipe(name:String, url:String){
        let recipeCollection = db.collection("recipes")
        
        //create Dictionary
        let newRecipeDict = ["name": name, "url": url]
        
        // Add a new document with a generated id
        var ref: DocumentReference? = nil
        ref = recipeCollection.addDocument(data: newRecipeDict) {err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func deleteRecipe(recipeID: String){
        // Delete the object from Firebase
        db.collection("recipes").document(recipeID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }

    func getRecipes()->[Recipe]{
        return recipeData
    }

}
