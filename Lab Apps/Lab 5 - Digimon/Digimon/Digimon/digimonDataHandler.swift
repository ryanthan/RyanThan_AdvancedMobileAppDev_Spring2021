//
//  digimonDataHandler.swift
//  Digimon
//
//  Created by Ryan Than on 3/7/21.
//

import Foundation

class DigimonDataHandler {
    var digimonData = [Digimon]() //Initialize array of Digimon
    var onDataUpdate: ((_ data: [Digimon]) -> Void)?
    
    func loadJSON() {
        //API from: https://digimon-api.herokuapp.com
        let urlPath = "https://digimon-api.vercel.app/api/digimon"
        
        guard let url = URL(string: urlPath)
        else {
            print("URL Error!")
            return
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"

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
    
    //Function to parse the JSON Data from the entire list of games
    func parseJSON(_ data: Data) {
        
        do {
            let apiData = try JSONDecoder().decode([Digimon].self, from: data)
            
            for digimon in apiData {
                digimonData.append(digimon)
                print(digimon)
            }
        }
        catch let jsonError {
            print("JSON Error: " + jsonError.localizedDescription)
            return
        }
        print("parseJSON Complete")
        onDataUpdate?(digimonData)
    }
    
    func getDigimonList() -> [Digimon] {
        return digimonData
    }
}
