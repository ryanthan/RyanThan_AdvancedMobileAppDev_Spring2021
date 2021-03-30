//
//  FavoritesDataHandler.swift
//  Ludos
//
//  Created by Ryan Than on 3/25/21.
//

import Foundation

//Class to handle all of the favorites plist data
class FavoritesDataHandler {
    var favoritesData = [Favorite]() //Initialize array of strings to store data
    
    //Function to get the URL path to the file directory
    func dataFileURL(_ filename:String) -> URL? {
        //Returns an array of URLs for the document directory in the user's home directory
        let urls = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)
        var url : URL?
        //Append the file name to the first item in the array which is the document directory
        url = urls.first?.appendingPathComponent(filename)
        //Return the URL of the data file or nil if it does not exist
        print("Data File URL: \(String(describing: url))")
        return url
    }
    
    //Function to load the data from the p-list
    func loadData(fileName: String){
        let fileURL = dataFileURL(fileName) //URL of data file
        
        if FileManager.default.fileExists(atPath: (fileURL?.path)!){ //If the data file exists, use it
            let url = fileURL!
            do {
                //Creates a data buffer with the contents of the plist
                let data = try Data(contentsOf: url)
                //Create an instance of PropertyListDecoder
                let decoder = PropertyListDecoder()
                //Decode the data using the structure of the Favorite class
                favoritesData = try decoder.decode([Favorite].self, from: data)
            } catch {
                print("Error: No file") //Error handling
            }
        }
        else {
            print("Error: Loading data - file does not exist") //Error handling
        }
    }
    
    //Function to save the data to the p-list
    func saveData(fileName: String){
        let fileURL = dataFileURL(fileName) //URL of data file
        
        do {
            //Create an instance of PropertyListEncoder
            let encoder = PropertyListEncoder()
            //Set format type to XML
            encoder.outputFormat = .xml
            let encodedData = try encoder.encode(favoritesData)
            //Write encoded data to the file
            try encodedData.write(to: fileURL!)
        } catch {
            print("Error writing to file")
        }
    }
    
    //Function to get the favorites list
    func getItems() -> [Favorite] {
        return favoritesData
    }
    
    //Function to add a game to the favorites list
    func addItem(newItem: Favorite) {
        favoritesData.append(newItem)
    }
    
    //Function to insert a game to the favorites list (for manual reordering)
    func insertItem(newItem: Favorite, index: Int) {
        favoritesData.insert(newItem, at: index)
    }
    
    //Function to remove a game from the favorites list
    func deleteItem(index: Int){
        favoritesData.remove(at: index)
    }
}
