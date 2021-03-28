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
    
    //Activity Indicator
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    //Function that runs when the view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        //Get the game's data from the API
        gameDataHandler.onSingleDataUpdate = {[weak self] (data:Game) in self?.viewWillAppear(true)}
        gameDataHandler.loadSingleJSON("https://rawg-video-games-database.p.rapidapi.com/games/\(selectedGameSlug)") //Load json with the specific game request
        
        gameDataHandler.onImageDataUpdate = {[weak self] (data:[Screenshot]) in self?.render()}
        gameDataHandler.loadImagesJSON("https://rawg.io/api/games/\(selectedGameSlug)/screenshots")
    }
    
    func render() {
        imageData = gameDataHandler.getScreenshots()
        
        for i in imageData {
            images.append(i.image!)
        }
        
        if images.isEmpty == true {
            loadImage(fromURL: "https://www.mediafreeware.com/images/no-screenshot.png", toImageView: screenShot1)
            loadImage(fromURL: "https://www.mediafreeware.com/images/no-screenshot.png", toImageView: screenShot2)
            loadImage(fromURL: "https://www.mediafreeware.com/images/no-screenshot.png", toImageView: screenShot3)
        } else if images.count == 1 {
            loadImage(fromURL: images[0], toImageView: screenShot1)
            loadImage(fromURL: "https://www.mediafreeware.com/images/no-screenshot.png", toImageView: screenShot2)
            loadImage(fromURL: "https://www.mediafreeware.com/images/no-screenshot.png", toImageView: screenShot3)
        } else if images.count == 2 {
            loadImage(fromURL: images[0], toImageView: screenShot1)
            loadImage(fromURL: images[1], toImageView: screenShot2)
            loadImage(fromURL: "https://www.mediafreeware.com/images/no-screenshot.png", toImageView: screenShot3)
        } else if images.count >= 3 {
            loadImage(fromURL: images[0], toImageView: screenShot1)
            loadImage(fromURL: images[1], toImageView: screenShot2)
            loadImage(fromURL: images[2], toImageView: screenShot3)
        }
    }
    
    //Save data when the UIApplicationWillResignActiveNotification notification is posted
    @objc func applicationWillResignActive(_ notification: Notification){
        favoritesData.saveData(fileName: dataFile)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        favoritesData.saveData(fileName: dataFile)
        images.removeAll()
    }
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        favoritesData.addItem(newItem: favoriteGameDetails)
        favoritesButton.setTitle("In favorites", for: .normal)
        favoritesButton.setTitleColor(.systemGray2, for: .normal)
        favoritesButton.isEnabled = false
        favoritesData.saveData(fileName: dataFile)
    }
    
    //Function that gets called when the detail view appears
    override func viewWillAppear(_ animated: Bool) {
        setLoadingScreen()
        //Setup and formatting:
        selectedGameDetails = gameDataHandler.getGameDetails() //Get the game details
        
        favoritesData.loadData(fileName: dataFile)
        favoritesList = favoritesData.getItems()
        //print(favoritesList)
        
        favoriteGameDetails.slug = selectedGameDetails.slug
        favoriteGameDetails.name = selectedGameDetails.name
        favoriteGameDetails.background_image = selectedGameDetails.background_image
        favoriteGameDetails.released = selectedGameDetails.released
        
        //application instance
        let app = UIApplication.shared
        //subscribe to the UIApplicationWillResignActiveNotification notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: app)
        
        for genre in selectedGameDetails.genres {
            genreList.append(genre.name!) //Add all of the game's genres to the list
        }
        for platform in selectedGameDetails.platforms {
            platformList.append((platform.platform?.name!)!) //Add all of the game's platforms to the list
        }
        
        if selectedGameDetails.released != "" {
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
        } else {
            releaseDateLabel?.text = "Release Date: ---"
        }
        
        //Get the game image from the URL
        loadImage(fromURL: selectedGameDetails.background_image ?? "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg", toImageView: backgroundImage)
        
        //Learned how to remove html tags from a string here: https://stackoverflow.com/questions/25983558/stripping-out-html-tags-from-a-string
        let cleanedDescription1 = selectedGameDetails.description!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let cleanedDescription2 = cleanedDescription1.replacingOccurrences(of: "&#39;", with: "'", range: nil)
        let cleanedDescription3 = cleanedDescription2.replacingOccurrences(of: "&quot;", with: "\"", range: nil)
        
        //Fill in the page details
        descriptionLabel?.text = cleanedDescription3 //Set the game description
        
        if platformLabel.text == "" {
            platformLabel?.text = platformList.joined(separator: ", ")
        }
        
        if genreLabel.text == "" {
            genreLabel?.text = genreList.joined(separator: ", ")
        }
        
        metacriticLabel?.text = "Metacritic Score: \(selectedGameDetails.metacritic ?? 0)"
        playtimeLabel?.text = "Average Playtime: \(selectedGameDetails.playtime ?? 0) hours"
        esrbLabel?.text = "ESRB Rating: \(selectedGameDetails.esrb_rating?.name ?? "---")"
        
        favoritesButton.layer.cornerRadius = 15
        metacriticButton.layer.cornerRadius = 15
        youtubeButton.layer.cornerRadius = 15
        
        if selectedGameDetails.metacritic_url == "" {
            metacriticButton.isEnabled = false
            metacriticButton.setTitle("Metacritic link not available.", for: .normal)
            metacriticButton.setTitleColor(.systemGray2, for: .normal)
        } else {
            metacriticButton.isEnabled = true
            metacriticButton.setTitle("View on Metacritic", for: .normal)
            metacriticButton.setTitleColor(.white, for: .normal)
        }
        
        for game in favoritesList {
            if favoriteGameDetails.slug == game.slug {
                favoritesButton.setTitle("In favorites", for: .normal)
                favoritesButton.setTitleColor(.systemGray2, for: .normal)
                favoritesButton.isEnabled = false
            }
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
        
        if titleLabel!.text != "" {
            removeLoadingScreen()
        }
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
    
    @IBAction func openRAWGApi(_ sender: UIButton) {
        UIApplication.shared.open(NSURL(string: "https://rawg.io/apidocs")! as URL)
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
}
