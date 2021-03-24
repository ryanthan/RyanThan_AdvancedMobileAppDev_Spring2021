//
//  PokemonGames.swift
//  Pokemon Trainer Info
//
//  Created by Ryan Than on 2/3/21.
//

import Foundation

struct PokemonGames: Decodable {
    let generation: String
    let games: [String]
}
