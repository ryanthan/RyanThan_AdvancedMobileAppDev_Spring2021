//
//  Recipe.swift
//  RecipesAuth
//
//  Created by Aileen Pierce on 3/8/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Recipe: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var url: String
}

