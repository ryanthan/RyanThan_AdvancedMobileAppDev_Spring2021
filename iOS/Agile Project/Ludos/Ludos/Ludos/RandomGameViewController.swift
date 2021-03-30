//
//  RandomGameViewController.swift
//  Ludos
//
//  Created by Ryan Than on 3/28/21.
//

import UIKit

class RandomGameViewController: UIViewController {
    
    //Variables
    var gameDataHandler = GameDataHandler()
    var gameSlug : String = ""
    var gameDetails = Game()
    var genreList = [String]()
    var platformList = [String]()
    var favoritesData = FavoritesDataHandler()
    let dataFile = "favoritesList.plist"
    var favoritesList = [Favorite]()
    var favoriteGameDetails = Favorite()
    let randomData = randomGameData()
    var randomSlug: String = ""
    let function = CommonFunctions()
    
    //Connections
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var platformsLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var moreDetailsButton: UIButton!
    
    //Function that runs when the view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark //Set the interface style to dark mode
        
        randomSlug = randomData.slugList.randomElement()! //Get a random game from the list
        
        //Get the random game's data from the API
        gameDataHandler.onSingleDataUpdate = {[weak self] (data:Game) in self?.viewWillAppear(true)}
        gameDataHandler.loadSingleJSON("https://rawg-video-games-database.p.rapidapi.com/games/\(randomSlug)")
    }

    //Save data when the UIApplicationWillResignActiveNotification notification is posted
    @objc func applicationWillResignActive(_ notification: Notification){
        favoritesData.saveData(fileName: dataFile)
    }
    
    //Save data when the view disappears
    override func viewDidDisappear(_ animated: Bool) {
        favoritesData.saveData(fileName: dataFile)
    }
    
    //Function that is called every time the view is loaded
    override func viewWillAppear(_ animated: Bool) {
        function.setLoadingScreen(self) //Set loading screen
        
        //Setup and formatting:
        favoritesButton.setTitle("Add to Favorites", for: .normal)
        favoritesButton.setTitleColor(.white, for: .normal)
        favoritesButton.isEnabled = true
        gameDetails = gameDataHandler.getGameDetails() //Get the game details
        
        //Get the favorites list data
        favoritesData.loadData(fileName: dataFile)
        favoritesList = favoritesData.getItems()
        favoriteGameDetails.slug = gameDetails.slug
        favoriteGameDetails.name = gameDetails.name
        favoriteGameDetails.background_image = gameDetails.background_image
        favoriteGameDetails.released = gameDetails.released
        
        //Application instance
        let app = UIApplication.shared
        //Subscribe to the UIApplicationWillResignActiveNotification notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: app)
        
        //Genres
        genreList.removeAll()
        genresLabel.text = ""
        for genre in gameDetails.genres {
            genreList.append(genre.name!) //Add all of the game's genres to the list
        }
        
        //Platforms
        platformList.removeAll()
        platformsLabel.text = ""
        for platform in gameDetails.platforms {
            platformList.append((platform.platform?.name!)!) //Add all of the game's platforms to the list
        }
        
        titleLabel.text = gameDetails.name //Set title label text
        
        //Get the game image from the URL
        function.loadImage(fromURL: gameDetails.background_image ?? "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg", toImageView: mainImageView)
        
        //Set label text:
        if platformsLabel.text == "" {
            platformsLabel?.text = platformList.joined(separator: ", ")
        }
        
        if genresLabel.text == "" {
            genresLabel?.text = genreList.joined(separator: ", ")
        }
        
        if titleLabel!.text != "" {
            function.removeLoadingScreen()
        }
        
        //Format buttons:
        favoritesButton.layer.cornerRadius = 15
        passButton.layer.cornerRadius = 15
        moreDetailsButton.layer.cornerRadius = 15
        
        //Check if the game is already in favorites
        for game in favoritesList {
            if randomSlug == game.slug {
                favoritesButton.setTitle("Already in Favorites!", for: .normal)
                favoritesButton.setTitleColor(.systemGray2, for: .normal)
                favoritesButton.isEnabled = false
            }
        }
    }
    
    
    // MARK: - Button Functions
    
    //Function that is called when the user clicks the add to favorites button
    @IBAction func addToFavoritesButton(_ sender: UIButton!) {
        //Add the game to the favorites list and save data
        favoritesData.addItem(newItem: favoriteGameDetails)
        favoritesData.saveData(fileName: dataFile)
        
        //Get the next random game
        gameDetails = Game()
        randomSlug = randomData.slugList.randomElement()!
        gameDataHandler.onSingleDataUpdate = {[weak self] (data:Game) in self?.viewWillAppear(true)}
        gameDataHandler.loadSingleJSON("https://rawg-video-games-database.p.rapidapi.com/games/\(randomSlug)")
        function.setLoadingScreen(self)
    }
    
    //Function that is called when the user clicks the pass button
    @IBAction func passButton(_ sender: Any) {
        //Pass the current game and get the next random game
        gameDetails = Game()
        randomSlug = randomData.slugList.randomElement()!
        gameDataHandler.onSingleDataUpdate = {[weak self] (data:Game) in self?.viewWillAppear(true)}
        gameDataHandler.loadSingleJSON("https://rawg-video-games-database.p.rapidapi.com/games/\(randomSlug)")
        function.setLoadingScreen(self)
    }
    
    //Function to display an alert when the user clicks the information button
    @IBAction func showInfoAlert(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Random Game Instructions", message: "This feature will display a random game! You can choose to add the current game to your favorites list, pass to the next game, or view more details about the current game.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Surprise me!", style: .default, handler: nil)
        alert.addAction(okayAction)
        alert.view.tintColor = .systemRed
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Segue Functions
    
    //Prepare to send data to the detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            //Sets the game slug and randomOn data for the destination view controller
            if let detailVC = segue.destination as? DetailViewController { //Downcast the destination property to the DetailViewController
                detailVC.selectedGameSlug = randomSlug
                detailVC.randomOn = true
            }
        }
    }
}
