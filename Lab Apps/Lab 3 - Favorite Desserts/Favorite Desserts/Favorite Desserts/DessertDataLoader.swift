//
//  DessertDataLoader.swift
//  Favorite Desserts
//
//  Created by Ryan Than on 2/14/21.
//

import Foundation

class DessertDataLoader{
    var allData = [DessertData]() //Array of type struct DessertData
    
    //Loads the data by decoding the plist
    func loadData(filename: String){
        if let pathURL = Bundle.main.url(forResource: filename, withExtension: "plist"){
            let plistdecoder = PropertyListDecoder() //Creates a property list decoder object
            do {
                let data = try Data(contentsOf: pathURL)
                allData = try plistdecoder.decode([DessertData].self, from: data) //Decodes the property list
            } catch { //Error handling
                print(error)
            }
        }
    }
    
    //Function to get array of desserts
    func getDesserts() -> [String]{
        var desserts = [String]()
        for item in allData{ //Loop through the data and get the desserts
            desserts.append(item.dessert)
        }
        return desserts
    }
    
    //Function to get array of dessert subtitles
    func getSubtitles() -> [String]{
        var subtitles = [String]()
        for item in allData{ //Loop through the data and get the subtitles
            subtitles.append(item.subtitle)
        }
        return subtitles
    }
    
    //Function to get array of specific dessert names
    func getNames(index:Int) -> [String] {
        return allData[index].names
    }
    
    //Function to add a dessert to the array
    func addDessert(index:Int, newDessert:String, newIndex: Int){
        allData[index].names.insert(newDessert, at: newIndex)
    }
    
    //Function to delete a dessert from the array
    func deleteDessert(index:Int, dessertIndex: Int){
        allData[index].names.remove(at: dessertIndex)
    }
}
