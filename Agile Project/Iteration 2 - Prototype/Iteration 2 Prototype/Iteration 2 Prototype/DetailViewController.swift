//
//  DetailViewController.swift
//  Iteration 2 Prototype
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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var metacriticButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    
    //Variables
    var gameDataHandler = GameDataHandler()
    var selectedGameSlug : String = ""
    var selectedGameDetails = Game()
    var genreList = [String]()
    var platformList = [String]()
    
    //Function that runs when the view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the game's data from the API
        gameDataHandler.onSingleDataUpdate = {[weak self] (data:Game) in self?.viewWillAppear(true)}
        gameDataHandler.loadSingleJSON("https://rawg-video-games-database.p.rapidapi.com/games/\(selectedGameSlug)") //Load json with the specific game request
    }
    
    //Function that gets called when the detail view appears
    override func viewWillAppear(_ animated: Bool) {
        //Setup and formatting:
        selectedGameDetails = gameDataHandler.getGameDetails() //Get the game details
        for genre in selectedGameDetails.genres {
            genreList.append(genre.name!) //Add all of the game's genres to the list
        }
        for platform in selectedGameDetails.platforms {
            platformList.append((platform.platform?.name!)!) //Add all of the game's platforms to the list
        }
        
        //Format the release date
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        if let date = dateFormatterGet.date(from: selectedGameDetails.released ?? "0000-00-00") {
            releaseDateLabel?.text = "Release Date: \(dateFormatterPrint.string(from: date))"
        } else {
           print("Date string error")
        }
        
        //Get the game image from the URL
        loadImage(fromURL: selectedGameDetails.background_image ?? "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg", toImageView: backgroundImage)
        
        //Learned how to remove html tags from a string here: https://stackoverflow.com/questions/25983558/stripping-out-html-tags-from-a-string
        let cleanedDescription1 = selectedGameDetails.description!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let cleanedDescription2 = cleanedDescription1.replacingOccurrences(of: "&#39;", with: "'", range: nil)
        let cleanedDescription3 = cleanedDescription2.replacingOccurrences(of: "&quot;", with: "\"", range: nil)
        
        //Fill in the page details
        descriptionLabel?.text = cleanedDescription3 //Set the game description
        platformLabel?.text = platformList.joined(separator: ", ")
        genreLabel?.text = genreList.joined(separator: ", ")
        
        metacriticLabel?.text = "Metacritic Score: \(selectedGameDetails.metacritic ?? 0)"
        playtimeLabel?.text = "Average Playtime: \(selectedGameDetails.playtime ?? 0) hours"
        
        if selectedGameDetails.metacritic_url == "" {
            metacriticButton.isHidden = true
        } else {
            metacriticButton.isHidden = false
        }
    }
    
    @IBAction func openMetacriticSite(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: selectedGameDetails.metacritic_url!)! as URL)
    }
    
    //Function to quickly grab images from the URL
    //Help from: https://stackoverflow.com/questions/44519925/swift-3-url-image-makes-uitableview-scroll-slow-issue
    func loadImage(fromURL urlString: String, toImageView imageView: UIImageView) {
        //If the URL is null, return
        guard let url = URL(string: urlString) else {
            return
        }

        //Add an activity indicator to the center of each imageView
        let activityView = UIActivityIndicatorView(style: .large)
        imageView.addSubview(activityView)
        activityView.frame = imageView.bounds
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        activityView.startAnimating()

        //Get the image from the URL
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //Stop the activity indicator and remove it
            DispatchQueue.main.async {
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            }
            
            //Update the image view if the data was successfully downloaded
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }.resume()
    }
}
