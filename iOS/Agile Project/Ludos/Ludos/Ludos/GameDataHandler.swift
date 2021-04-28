//
//  GameDataHandler.swift
//  Ludos
//
//  Created by Ryan Than on 3/25/21.
//

import Foundation
import UIKit

//Class to handle all of the API data
class GameDataHandler {
    var game = Game()
    var gameData = GameData()
    var screenShotData = ScreenshotData()
    var errorBool = false
    
    //Closures:
    var onDataUpdate: ((_ data: [Game]) -> Void)?
    var onSingleDataUpdate: ((_ data: Game) -> Void)?
    var onImageDataUpdate: ((_ data: [Screenshot]) -> Void)?
    
    //Function to load a list of games from the API
    func loadListJSON(_ urlPath : String) {
        errorBool = false
        let headers = [
            "x-rapidapi-key": "4153d01988msh5a027dd023775dap1349adjsn965e8b37b71f",
            "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com"
        ]
                
        guard let url = URL(string: urlPath)
        else {
            print("URL Error!")
            return
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print(statusCode)
                guard statusCode == 200
                else {
                    print("File Download Error in loadListJSON")
                    self.errorBool = true
                    return
                }
                print("Download Successful")
                DispatchQueue.main.async { self.parseJSON(data!)}
            } else {
                print("Internet Connection Error!")
            }
        })
        session.resume()
    }
    
    //Function to load a single game's details from the API
    func loadSingleJSON(_ urlPath : String) {
        errorBool = false
        let headers = [
            "x-rapidapi-key": "4153d01988msh5a027dd023775dap1349adjsn965e8b37b71f",
            "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com"
        ]
                
        guard let url = URL(string: urlPath)
        else {
            print("URL Error!")
            return
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print(statusCode)
                guard statusCode == 200
                else {
                    print("File Download Error in loadSingleJSON")
                    self.errorBool = true
                    return
                }
                print("Download Successful")
                DispatchQueue.main.async { self.parseJSONSingleGame(data!)}
            } else {
                print("Internet Connection Error!")
            }
        })
        session.resume()
    }
    
    //Function to load a single game's screenshots from the API
    func loadImagesJSON(_ urlPath : String) {
        errorBool = false
        let headers = [
            "x-rapidapi-key": "4153d01988msh5a027dd023775dap1349adjsn965e8b37b71f",
            "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com"
        ]
                
        guard let url = URL(string: urlPath)
        else {
            print("URL Error!")
            return
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print(statusCode)
                guard statusCode == 200
                else {
                    print("File Download Error in loadImagesJSON")
                    self.errorBool = true
                    return
                }
                print("Download Successful")
                DispatchQueue.main.async { self.parseJSONImages(data!)}
            } else {
                print("Internet Connection Error!")
            }
        })
        session.resume()
    }
    
    //Function to parse the JSON Data from the entire list of games
    func parseJSON(_ data: Data) {
        errorBool = false
        do {
            let apiData = try JSONDecoder().decode(GameData.self, from: data)
            //Throw an error if the search term produces no results
            if apiData.results.isEmpty == true {
                errorBool = true
                print("No results can be found with the search term.")
            } else {
                for game in apiData.results{
                    gameData.results.append(game)
                }
            }
        }
        catch let jsonError {
            errorBool = true
            print("JSON Error in parseJSON")
            print(jsonError)
        }
        print("parseJSON Complete")
        onDataUpdate?(gameData.results)
    }
    
    //Function to parse the JSON data from a single game
    func parseJSONSingleGame(_ data: Data) {
        errorBool = false
        do {
            let apiData = try JSONDecoder().decode(Game.self, from: data)
            game = apiData
        }
        catch let jsonError {
            errorBool = true
            print("JSON Error in parseJSONSingleGame")
            print(jsonError.localizedDescription)
        }
        print("parseJSON Complete")
        onSingleDataUpdate?(game)
    }
    
    //Function to parse the screenshot JSON Data from a single game
    func parseJSONImages(_ data: Data) {
        errorBool = false
        do {
            let apiData = try JSONDecoder().decode(ScreenshotData.self, from: data)
            for image in apiData.results{
                screenShotData.results.append(image)
            }
        }
        catch let jsonError {
            errorBool = true
            print("JSON Error in parseJSONImages")
            print(jsonError.localizedDescription)
        }
        print("parseJSON Complete")
        onImageDataUpdate?(screenShotData.results)
    }
    
    //Function to get the full list of games
    func getGames() -> [Game] {
        return gameData.results
    }
    
    //Function the get a single game's details
    func getGameDetails() -> Game {
        return game
    }
    
    //Function the get a single game's screenshots
    func getScreenshots() -> [Screenshot] {
        return screenShotData.results
    }
    
    //Function to clear games from the current list
    func clearGames() {
        gameData.results.removeAll()
    }
    
    //Function to determine if there was an error reading the JSON data
    func JSONError() -> Bool {
        return errorBool
    }
}
