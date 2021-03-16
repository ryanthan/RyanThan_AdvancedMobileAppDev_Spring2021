//
//  GameDataHandler.swift
//  Iteration 2 Prototype
//
//  Created by Ryan Than on 2/22/21.
//

import Foundation

class GameDataHandler {
    var game = Game()
    var gameData = GameData()
    
    //Closure takes an array of Game as its parameter and Void as its return type
    var onDataUpdate: ((_ data: [Game]) -> Void)?
    var onSingleDataUpdate: ((_ data: Game) -> Void)?
    
    //Function to load a list of games from the API
    func loadListJSON(_ urlPath : String) {
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
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            print(statusCode)
            guard statusCode == 200
            else {
                print("File Download Error")
                return
            }
            print("Download Successful")
            DispatchQueue.main.async { self.parseJSON(data!)}
        })
        session.resume()
    }
    
    //Function to load a single game's details from the API
    func loadSingleJSON(_ urlPath : String) {
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
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            print(statusCode)
            guard statusCode == 200
            else {
                print("File Download Error")
                return
            }
            print("Download Successful")
            DispatchQueue.main.async { self.parseJSONSingleGame(data!)}
        })
        session.resume()
    }
    
    //Function to parse the JSON Data from the entire list of games
    func parseJSON(_ data: Data) {
        do {
            let apiData = try JSONDecoder().decode(GameData.self, from: data)
            for game in apiData.results{
                gameData.results.append(game)
                //print(game) //Uncomment to see all of the game details
            }
        }
        catch let jsonError {
            print("JSON Error")
            print(jsonError.localizedDescription)
            return
        }
        print("parseJSON Complete")
        onDataUpdate?(gameData.results)
    }
    
    //Function to parse the JSON data from a single game
    func parseJSONSingleGame(_ data: Data) {
        do {
            let apiData = try JSONDecoder().decode(Game.self, from: data)
            game = apiData
            //print(game) //Uncomment to see all of the game details
        }
        catch let jsonError {
            print("JSON Error")
            print(jsonError.localizedDescription)
            return
        }
        print("parseJSON Complete")
        onSingleDataUpdate?(game)
    }
    
    //Function to get the full list of games
    func getGames() -> [Game] {
        return gameData.results
    }
    
    //Function the get a single game's details
    func getGameDetails() -> Game {
        return game
    }
}
