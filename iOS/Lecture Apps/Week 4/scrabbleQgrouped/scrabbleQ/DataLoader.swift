//
//  DataLoader.swift
//  scrabbleQ
//
//  Created by Aileen Pierce
//

import Foundation

class DataLoader{
    //Similar to the scrabbleQ app but using an array of GroupedWords instead
    var allData  = [GroupedWords]()

    func loadData(filename: String){
        // URL for our plist
        if let pathURL = Bundle.main.url(forResource: filename, withExtension:  "plist") {
            //initialize a property list decoder object
            let plistdecoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: pathURL)
                //decodes the property list
                allData = try plistdecoder.decode([GroupedWords].self, from: data) //allData includes the group letters and the words
            } catch {
                //handle error
                print("Cannot load data")
            }
        }
    }

    func getWords()->[GroupedWords]{
        return allData
    }

    func getLetters()->[String]{
        var letters = [String]()
        for firstLetter in allData{
            letters.append(firstLetter.letter)
        }
        //Sorts the array of letters before returning
        letters.sort(by: {$0 < $1})
        return letters
    }
}

