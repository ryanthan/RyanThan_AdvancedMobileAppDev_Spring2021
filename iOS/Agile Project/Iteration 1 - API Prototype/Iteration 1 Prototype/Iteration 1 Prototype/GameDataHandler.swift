//
//  GameDataHandler.swift
//  Iteration 1 Prototype
//
//  Created by Ryan Than on 2/22/21.
//

import Foundation

class GameDataHandler {
    var game = Game()
    var gameData = GameData()
    
    //closure takes an array of Joke as its parameter and Void as its return type
    var onDataUpdate: ((_ data: [Game]) -> Void)?
    var onSingleDataUpdate: ((_ data: Game) -> Void)?
    
    func loadJSON(_ urlPath : String) {
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
            if url == URL(string: "https://rawg-video-games-database.p.rapidapi.com/games") {
                DispatchQueue.main.async { self.parseJSON(data!)}
            } else {
                DispatchQueue.main.async { self.parseJSONSingleGame(data!)}
            }
        })
        
        session.resume()
    }
    
    //Function to parse the JSON Data from the entire list of games
    func parseJSON(_ data: Data) {
        do {
            let apiData = try JSONDecoder().decode(GameData.self, from: data)
            for game in apiData.results{
                gameData.results.append(game)
                print(game)
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
            print(game)
        }
        catch let jsonError {
            print("JSON Error")
            print(jsonError.localizedDescription)
            return
        }
        print("parseJSON Complete")
        onSingleDataUpdate?(game)
    }
    
    func getGames() -> [Game] {
        return gameData.results
    }
    
    func getGameDetails() -> Game {
        return game
    }
}
