//
//  DetailViewController.swift
//  Ludos
//
//  Created by Ryan Than on 3/25/21.
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
    @IBOutlet weak var esrbLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var metacriticButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var screenShot1: UIImageView!
    @IBOutlet weak var screenShot2: UIImageView!
    @IBOutlet weak var screenShot3: UIImageView!
    
    //Variables
    var gameDataHandler = GameDataHandler()
    var selectedGameSlug : String = ""
    var selectedGameDetails = Game()
    var genreList = [String]()
    var platformList = [String]()
    var titleLabel : UILabel?
    var favoritesData = FavoritesDataHandler()
    let dataFile = "favoritesList.plist"
    var favoritesList = [Favorite]()
    var favoriteGameDetails = Favorite()
    var imageData = [Screenshot]()
    var images = [String]()
    var randomOn = false
    let function = CommonFunctions()
    
    //Function that runs when the view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark //Set the interface style to dark mode
        
        //Initially make the buttons disabled while the data loads
        favoritesButton.isEnabled = false
        metacriticButton.isEnabled = false
        youtubeButton.isEnabled = false
                
        //Get the game's data from the API
        gameDataHandler.onSingleDataUpdate = {[weak self] (data:Game) in self?.viewWillAppear(true)}
        gameDataHandler.loadSingleJSON("https://rawg-video-games-database.p.rapidapi.com/games/\(selectedGameSlug)")
        
        //Get the game's screenshot data from the API
        gameDataHandler.onImageDataUpdate = {[weak self] (data:[Screenshot]) in self?.renderScreenshots()}
        gameDataHandler.loadImagesJSON("https://rawg.io/api/games/\(selectedGameSlug)/screenshots")
    }
    
    //Function that is called every time the view is loaded
    override func viewWillAppear(_ animated: Bool) {
        function.setLoadingScreen(self) //Set loading screen
        
        //If the user came from the random games feature, hide the add to favorites button
        if randomOn == true {
            favoritesButton.isHidden = true
        } else {
            favoritesButton.isHidden = false
        }
        
        //Setup and formatting:
        selectedGameDetails = gameDataHandler.getGameDetails() //Get the game details
        
        //Get favorites list data
        favoritesData.loadData(fileName: dataFile)
        favoritesList = favoritesData.getItems()
        favoriteGameDetails.slug = selectedGameDetails.slug
        favoriteGameDetails.name = selectedGameDetails.name
        favoriteGameDetails.background_image = selectedGameDetails.background_image
        favoriteGameDetails.released = selectedGameDetails.released
        
        //Application instance
        let app = UIApplication.shared
        //Subscribe to the UIApplicationWillResignActiveNotification notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: app)
        
        //Genres:
        for genre in selectedGameDetails.genres {
            genreList.append(genre.name!) //Add all of the game's genres to the list
        }
        
        //Platforms:
        for platform in selectedGameDetails.platforms {
            platformList.append((platform.platform?.name!)!) //Add all of the game's platforms to the list
        }
        
        //Format the release date
        if selectedGameDetails.released != "" {
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd, yyyy"
            
            if let date = dateFormatterGet.date(from: selectedGameDetails.released ?? "0000-00-00") {
                releaseDateLabel?.text = "Release Date: \(dateFormatterPrint.string(from: date))"
            } else {
               print("Date string error")
            }
        } else {
            releaseDateLabel?.text = "Release Date: ---"
        }
        
        //Get the game image from the URL
        function.loadImage(fromURL: selectedGameDetails.background_image ?? "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg", toImageView: backgroundImage)
        
        //Clean up the game's description:
        //Learned how to remove html tags from a string here: https://stackoverflow.com/questions/25983558/stripping-out-html-tags-from-a-string
        let cleanedDescription1 = selectedGameDetails.description!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let cleanedDescription2 = cleanedDescription1.replacingOccurrences(of: "&#39;", with: "'", range: nil)
        let cleanedDescription3 = cleanedDescription2.replacingOccurrences(of: "&quot;", with: "\"", range: nil)
        
        //Fill in the page details
        descriptionLabel?.text = cleanedDescription3 //Set the game description
        
        //Fill in labels:
        if platformLabel.text == "" {
            platformLabel?.text = platformList.joined(separator: ", ")
        }
        if genreLabel.text == "" {
            genreLabel?.text = genreList.joined(separator: ", ")
        }
        
        metacriticLabel?.text = "Metacritic Score: \(selectedGameDetails.metacritic ?? 0)"
        playtimeLabel?.text = "Average Playtime: \(selectedGameDetails.playtime ?? 0) hours"
        esrbLabel?.text = "ESRB Rating: \(selectedGameDetails.esrb_rating?.name ?? "---")"
        
        //Customize buttons
        favoritesButton.layer.cornerRadius = 15
        metacriticButton.layer.cornerRadius = 15
        youtubeButton.layer.cornerRadius = 15
        
        //Change the button text if the Metacritic link is unavailable
        if selectedGameDetails.metacritic_url == "" {
            metacriticButton.isEnabled = false
            metacriticButton.setTitle("Metacritic link not available.", for: .normal)
            metacriticButton.setTitleColor(.systemGray2, for: .normal)
        } else {
            metacriticButton.isEnabled = true
            metacriticButton.setTitle("View on Metacritic", for: .normal)
            metacriticButton.setTitleColor(.white, for: .normal)
        }
        
        //Add a unique title label to account for long game names
        titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        titleLabel!.backgroundColor = UIColor.clear
        titleLabel!.numberOfLines = 0
        titleLabel!.textAlignment = NSTextAlignment.center
        titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel!.textColor = UIColor.white
        titleLabel!.text = selectedGameDetails.name
        self.navigationItem.titleView = titleLabel
        
        //Remove the loading screen if the data is loaded
        if titleLabel!.text != "" {
            function.removeLoadingScreen()
            youtubeButton.isEnabled = true //Enable button
            favoritesButton.isEnabled = true //Enable button
            
            //Check if the game is already in the favorites list
            for game in favoritesList {
                if favoriteGameDetails.slug == game.slug {
                    favoritesButton.setTitle("In favorites", for: .normal)
                    favoritesButton.setTitleColor(.systemGray2, for: .normal)
                    favoritesButton.isEnabled = false
                }
            }
        }
    }
    
    //Save data when the view disappears
    override func viewDidDisappear(_ animated: Bool) {
        favoritesData.saveData(fileName: dataFile)
        images.removeAll()
    }
    
    //Function to add screenshots to the detail view
    func renderScreenshots() {
        imageData = gameDataHandler.getScreenshots() //Get image data
        
        //Append image to array
        for i in imageData {
            images.append(i.image!)
        }
        
        //Add screenshots to detail view
        if images.isEmpty == true {
            function.loadImage(fromURL: "https://www.mediafreeware.com/images/no-screenshot.png", toImageView: screenShot1)
            function.loadImage(fromURL: "https://www.mediafreeware.com/images/no-screenshot.png", toImageView: screenShot2)
            function.loadImage(fromURL: "https://www.mediafreeware.com/images/no-screenshot.png", toImageView: screenShot3)
        } else if images.count == 1 {
            function.loadImage(fromURL: images[0], toImageView: screenShot1)
            function.loadImage(fromURL: "https://www.mediafreeware.com/images/no-screenshot.png", toImageView: screenShot2)
            function.loadImage(fromURL: "https://www.mediafreeware.com/images/no-screenshot.png", toImageView: screenShot3)
        } else if images.count == 2 {
            function.loadImage(fromURL: images[0], toImageView: screenShot1)
            function.loadImage(fromURL: images[1], toImageView: screenShot2)
            function.loadImage(fromURL: "https://www.mediafreeware.com/images/no-screenshot.png", toImageView: screenShot3)
        } else if images.count >= 3 {
            function.loadImage(fromURL: images[0], toImageView: screenShot1)
            function.loadImage(fromURL: images[1], toImageView: screenShot2)
            function.loadImage(fromURL: images[2], toImageView: screenShot3)
        }
    }
    
    //Save data when the UIApplicationWillResignActiveNotification notification is posted
    @objc func applicationWillResignActive(_ notification: Notification){
        favoritesData.saveData(fileName: dataFile)
    }
    
    
    // MARK: - Button Functions
    
    //Add the current game to the favorites list when the button is pressed
    @IBAction func addToFavorites(_ sender: UIButton) {
        favoritesData.addItem(newItem: favoriteGameDetails)
        favoritesButton.setTitle("In favorites", for: .normal)
        favoritesButton.setTitleColor(.systemGray2, for: .normal)
        favoritesButton.isEnabled = false
        favoritesData.saveData(fileName: dataFile)
    }
    
    //Open the Metacritic link (if available) when the button is pressed
    @IBAction func openMetacriticSite(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: selectedGameDetails.metacritic_url!)! as URL)
    }
    
    //Open a Youtube search url when the button is pressed
    @IBAction func openYoutubeSearch(_ sender: Any) {
        let lowerCaseName = selectedGameDetails.name?.lowercased()
        let removeAccents = lowerCaseName!.folding(options: .diacriticInsensitive, locale: .current)
        let updatedName = removeAccents.replacingOccurrences(of: ",", with: "", options: .literal, range: nil)
        let updatedName2 = updatedName.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let finalSearch = updatedName2 + "+game+trailer"
        UIApplication.shared.open(NSURL(string: "https://www.youtube.com/results?search_query=\(finalSearch)")! as URL)
    }
    
    //Open a link to the API's website when the button is pressed
    @IBAction func openRAWGApi(_ sender: UIButton) {
        UIApplication.shared.open(NSURL(string: "https://rawg.io/apidocs")! as URL)
    }
}
