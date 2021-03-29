//
//  RandomGameViewController.swift
//  Ludos
//
//  Created by Ryan Than on 3/28/21.
//

import UIKit

class RandomGameViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var platformsLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var moreDetailsButton: UIButton!
    
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
    
    //Activity Indicator
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        randomSlug = randomData.slugList.randomElement()!
        
        //Get the game's data from the API
        gameDataHandler.onSingleDataUpdate = {[weak self] (data:Game) in self?.viewWillAppear(true)}
        gameDataHandler.loadSingleJSON("https://rawg-video-games-database.p.rapidapi.com/games/\(randomSlug)")
    }
    
    @IBAction func addToFavoritesButton(_ sender: UIButton!) {
        favoritesData.addItem(newItem: favoriteGameDetails)
        favoritesData.saveData(fileName: dataFile)
        
        gameDetails = Game()
        randomSlug = randomData.slugList.randomElement()!
        gameDataHandler.onSingleDataUpdate = {[weak self] (data:Game) in self?.viewWillAppear(true)}
        gameDataHandler.loadSingleJSON("https://rawg-video-games-database.p.rapidapi.com/games/\(randomSlug)")
        setLoadingScreen()
    }
    
    @IBAction func passButton(_ sender: Any) {
        gameDetails = Game()
        randomSlug = randomData.slugList.randomElement()!
        gameDataHandler.onSingleDataUpdate = {[weak self] (data:Game) in self?.viewWillAppear(true)}
        gameDataHandler.loadSingleJSON("https://rawg-video-games-database.p.rapidapi.com/games/\(randomSlug)")
        setLoadingScreen()
    }

    //Save data when the UIApplicationWillResignActiveNotification notification is posted
    @objc func applicationWillResignActive(_ notification: Notification){
        favoritesData.saveData(fileName: dataFile)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        favoritesData.saveData(fileName: dataFile)
    }
    
    //Function that gets called when the detail view appears
    override func viewWillAppear(_ animated: Bool) {
        setLoadingScreen()
        favoritesButton.setTitle("Add to Favorites", for: .normal)
        favoritesButton.setTitleColor(.white, for: .normal)
        favoritesButton.isEnabled = true
        //Setup and formatting:
        gameDetails = gameDataHandler.getGameDetails() //Get the game details
        
        favoritesData.loadData(fileName: dataFile)
        favoritesList = favoritesData.getItems()
        //print(favoritesList)
        
        favoriteGameDetails.slug = gameDetails.slug
        favoriteGameDetails.name = gameDetails.name
        favoriteGameDetails.background_image = gameDetails.background_image
        favoriteGameDetails.released = gameDetails.released
        
        //application instance
        let app = UIApplication.shared
        //subscribe to the UIApplicationWillResignActiveNotification notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: app)
        
        genreList.removeAll()
        genresLabel.text = ""
        for genre in gameDetails.genres {
            genreList.append(genre.name!) //Add all of the game's genres to the list
        }
        
        platformList.removeAll()
        platformsLabel.text = ""
        for platform in gameDetails.platforms {
            platformList.append((platform.platform?.name!)!) //Add all of the game's platforms to the list
        }
        
        titleLabel.text = gameDetails.name
        
        //Get the game image from the URL
        loadImage(fromURL: gameDetails.background_image ?? "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg", toImageView: mainImageView)
        
        if platformsLabel.text == "" {
            platformsLabel?.text = platformList.joined(separator: ", ")
        }
        
        if genresLabel.text == "" {
            genresLabel?.text = genreList.joined(separator: ", ")
        }
        
        if titleLabel!.text != "" {
            removeLoadingScreen()
        }
        
        favoritesButton.layer.cornerRadius = 15
        passButton.layer.cornerRadius = 15
        moreDetailsButton.layer.cornerRadius = 15
        
        for game in favoritesList {
            if randomSlug == game.slug {
                favoritesButton.setTitle("Already in Favorites!", for: .normal)
                favoritesButton.setTitleColor(.systemGray2, for: .normal)
                favoritesButton.isEnabled = false
            }
        }
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
    
    //Function to display a loading screen while the data loads
    private func setLoadingScreen() {
        //Set up the view that contains the loading text and activity indicator
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (view.frame.width / 2) - (width / 2)
        let y = (view.frame.height / 2) - (height / 2)
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        //Configure the loading text label
        loadingLabel.textColor = .white
        loadingLabel.textAlignment = NSTextAlignment.right
        loadingLabel.text = "Loading..."
        loadingLabel.backgroundColor? = .systemGray5
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 110, height: 40)
        loadingLabel.layer.cornerRadius = 10
        loadingLabel.layer.masksToBounds = true
        loadingLabel.isHidden = false

        //Configure the activity indicator
        spinner.style = .medium
        spinner.color = .white
        spinner.frame = CGRect(x: 2, y: 5, width: 30, height: 30)
        spinner.startAnimating()

        //Adds the text and activity indicator to the view
        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(spinner)

        //Present the view
        view.addSubview(loadingView)
    }

    //Remove the loading screen
    private func removeLoadingScreen() {
        //Hides the text and stops the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
    }
    
    @IBAction func showInfoAlert(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Random Game Instructions", message: "This feature will display a random game! You can choose to add the current game to your favorites list, pass to the next game, or view more details about the current game.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Surprise me!", style: .default, handler: nil)
        alert.addAction(okayAction)
        alert.view.tintColor = .systemRed
        present(alert, animated: true, completion: nil)
    }
    
    //Prepare to send data to the detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailVC = segue.destination as? DetailViewController { //Downcast the destination property to the DetailTableViewController
                detailVC.selectedGameSlug = randomSlug
                detailVC.randomOn = true
            }
        }
    }
}
