//
//  GameData.swift
//  Iteration 1 Prototype
//
//  Created by Ryan Than on 2/21/21.
//

import Foundation

//Data structures to store data
struct Game : Decodable {
    let id : Int
    let slug : String
    let name : String
    let released : String
    let background_image : String
    let metacritic : Int
    let playtime : Int
    let description : String?
}

struct GameData : Decodable {
    var results = [Game]()
}
