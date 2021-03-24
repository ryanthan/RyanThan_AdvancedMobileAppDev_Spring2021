//
//  DataLoader.swift
//  Pokemon Trainer Info
//
//  Created by Ryan Than on 2/3/21.
//

import Foundation

//Class to load in data from the plist
class DataLoader {
    var allData = [PokemonGames]()
    
    func loadData(filename: String) {
        if let pathURL = Bundle.main.url(forResource: filename, withExtension: "plist") {
            //Initialize a property list decoder object
            let plistdecoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: pathURL)
                //Decodes the property list
                allData = try plistdecoder.decode([PokemonGames].self, from: data)
            } catch {
                //Handle error
                print("Cannot load data!")
            }
        }
    }
    
    //Get the pokemon game generations and returns them as an array of strings
    func getGenerations() -> [String] {
        var generations = [String]()
        for gen in allData {
            generations.append(gen.generation)
        }
        return generations
    }
    
    func getGames(index: Int) -> [String] {
        return allData[index].games
    }
}
