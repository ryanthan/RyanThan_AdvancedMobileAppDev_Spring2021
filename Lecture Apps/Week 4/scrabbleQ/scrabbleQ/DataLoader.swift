//
//  DataLoader.swift
//  scrabbleQ
//
//  Created by Ryan Than on 2/8/21.
//

import Foundation

class DataLoader{
    var qNoUWords = [String]() //Array of strings
    
    //Function to load data in from the plist
    func loadData(filename: String){
        //URL for the plist
        if let pathURL = Bundle.main.url(forResource: filename, withExtension:  "plist") {
            //Initialize a property list decoder object
            let plistdecoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: pathURL)
                //Decodes the property list
                qNoUWords = try plistdecoder.decode([String].self, from: data)
            } catch {
                //Error handling
                print("Cannot load data")
            }
        }
    }
    
    //Function that returns the string array with all the words
    func getWords()->[String]{
        return qNoUWords
    }

}
