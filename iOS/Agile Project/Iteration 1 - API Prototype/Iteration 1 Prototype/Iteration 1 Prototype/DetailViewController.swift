//
//  DetailViewController.swift
//  Iteration 1 Prototype
//
//  Created by Ryan Than on 2/22/21.
//

import UIKit

class DetailViewController: UIViewController {
    //Connections
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var metacriticLabel: UILabel!
    @IBOutlet weak var playtimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //Variables
    var gameDataHandler = GameDataHandler()
    var selectedGameSlug : String = ""
    var selectedGameDetails = Game(id: 0, slug: "", name: "", released: "", background_image: "", metacritic: 0, playtime: 0, description: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        gameDataHandler.onSingleDataUpdate = {[weak self] (data:Game) in self?.viewWillAppear(true)}
        gameDataHandler.loadJSON("https://rawg-video-games-database.p.rapidapi.com/games/\(selectedGameSlug)") //Load json with the specific game request
    }
    
    //Function that gets called when the detail view appears
    override func viewWillAppear(_ animated: Bool) {
        selectedGameDetails = gameDataHandler.getGameDetails() //Get the game details
        
        //Get the game image from the URL
        if let url = URL(string: selectedGameDetails.background_image) { //Set the image url
            let data = try? Data(contentsOf: url) //Test if the url data is usable
            
            if let image = UIImage(data: data!) { //Set the image
                image.withTintColor(UIColor.systemGray2)
                backgroundImage?.image = image
            }
        }
        
        //Learned how to remove html tags from a string here: https://stackoverflow.com/questions/25983558/stripping-out-html-tags-from-a-string
        let cleanedDescription = selectedGameDetails.description!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        descriptionLabel?.text = cleanedDescription //Set the game description
        
        releaseDateLabel?.text = "Release Date: \(selectedGameDetails.released)"
        metacriticLabel?.text = "Metacritic Score: \(selectedGameDetails.metacritic)"
        playtimeLabel?.text = "Average Playtime: \(selectedGameDetails.playtime) hours"
    }
}
