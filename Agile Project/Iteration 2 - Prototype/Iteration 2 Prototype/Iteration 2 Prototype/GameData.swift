//
//  GameData.swift
//  Iteration 2 Prototype
//
//  Created by Ryan Than on 2/21/21.
//

import Foundation

//Data structures to store data from the API
struct GameData : Decodable {
    var next : String?
    var previous : String?
    var results : [Game]
    
    init() {
        next = ""
        previous = ""
        results = [Game]()
    }
}

struct Game : Decodable {
    let id : Int?
    let slug : String?
    let name : String?
    let released : String?
    let background_image : String?
    let background_image_additional : String?
    let metacritic : Int?
    let playtime : Int?
    let description : String?
    let metacritic_url : String?
    var esrb_rating : esrbRatingData?
    var platforms : [PlatformData]
    var genres : [GenreData]
    
    init() {
        id = 0
        slug = ""
        name = ""
        released = ""
        background_image = ""
        background_image_additional = ""
        metacritic = 0
        playtime = 0
        description = ""
        metacritic_url = ""
        esrb_rating = nil
        platforms = [PlatformData]()
        genres = [GenreData]()
    }
}

struct esrbRatingData : Decodable {
    let name : String?
    
    init() {
        name = ""
    }
}

struct PlatformData : Decodable {
    var platform : Platform?
    
    init() {
        platform = nil
    }
}

struct Platform : Decodable {
    let name : String?
    
    init() {
        name = ""
    }
}

struct GenreData : Decodable {
    let name : String?
    
    init() {
        name = ""
    }
}


struct Favorite : Codable {
    var slug : String?
    var name : String?
    var released : String?
    var background_image : String?
    
    init() {
        slug = ""
        name = ""
        released = ""
        background_image = ""
    }
}
