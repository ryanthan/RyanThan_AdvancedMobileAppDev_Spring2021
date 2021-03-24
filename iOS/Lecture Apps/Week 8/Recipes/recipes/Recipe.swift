//
//  Recipe.swift
//  Recipes
//
//  Created by Aileen Pierce
//

import Foundation
import FirebaseFirestoreSwift

struct Recipe: Codable, Identifiable{
    @DocumentID var id: String?
    var name: String
    var url: String
}
