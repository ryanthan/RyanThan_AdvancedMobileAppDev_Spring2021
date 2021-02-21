//
//  DataHandler.swift
//  Landscape Details
//
//  Created by Ryan Than on 2/17/21.
//

import Foundation

class DataHandler{
    var allData = [Location]() //Initialize a variable to store all of the data
    
    //Function to decode the property list
    func loadData(fileName: String){
        if let pathURL = Bundle.main.url(forResource: fileName, withExtension: "plist"){
            //Creates a property list decoder object
            let plistdecoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: pathURL)
                //Decodes the property list
                allData = try plistdecoder.decode([Location].self, from: data)
            } catch {
                //Error handling
                print(error)
            }
        }
    }
    
    //Function to get the location names
    func getLocations() -> [String]{
        var locations = [String]()
        for location in allData{
            locations.append(location.name)
        }
        return locations
    }
    
    //Function to get the location URL
    func getURL(index:Int) -> String {
        return allData[index].url
    }
}
