//
//  MainTableViewController.swift
//  Ludos
//
//  Created by Ryan Than on 3/25/21.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    //Variables & Connections:
    var games = [Game]()
    var rowHeight : CGFloat!
    var gameDataHandler = GameDataHandler()
    var genreList = [String]()
    var platformList = [String]()
    var pageNumber = 2
    var filterPageNumber = 2
    var searchActive = false
    var platformFilter : String = "None"
    var genreFilter : String = "None"
    var filterActive = false
    var filterURL: String!
    var nextFilterURL: String?
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var upButton: UIBarButtonItem!
    
    //Activity Indicator
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Function that runs when the view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        setLoadingScreen() //Sets a loading screen while the API data loads
        activityIndicator.isHidden = true //Hide the activity indicator at first
        
        //Initially make the buttons disabled while the data loads
        searchButton.isEnabled = false
        upButton.isEnabled = false
        filterButton.isEnabled = false
        
        //Set the row height for the table view
        //Help from: https://medium.com/better-programming/how-to-create-custom-uitableviewcell-f4e69193bab
        self.rowHeight = UIScreen.main.traitCollection.userInterfaceIdiom == .phone ? 152 : 75
        self.tableView.rowHeight = self.rowHeight
        
        //Get the first set of data from the API
        gameDataHandler.onDataUpdate = {[weak self] (data:[Game]) in self?.render()}
        gameDataHandler.loadListJSON("https://rawg-video-games-database.p.rapidapi.com/games")
    }
    
    @IBAction func SearchButton(_ sender: UIBarButtonItem) {
        let searchAlert = UIAlertController(title: "Search", message: "Please enter a search term. Leave blank to return to the full list.", preferredStyle: .alert)
        searchAlert.addTextField(configurationHandler: {(UITextField) in}) //Add textfield to the alert
        
        //Create cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        searchAlert.addAction(cancelAction)
        
        //Create add button
        let searchItemAction = UIAlertAction(title: "Search", style: .default, handler: {(UIAlertAction) in
            let searchTextField = searchAlert.textFields![0] //Gets textfield
            let searchString = searchTextField.text! //Gets text in the textfield
            
            if searchString.isEmpty == false {
                self.setLoadingScreen() //Sets a loading screen while the API data loads
                self.gameDataHandler.clearGames()
                let topIndex = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: topIndex, at: .top, animated: true)
                self.gameDataHandler.onDataUpdate = {[weak self] (data:[Game]) in self?.render()}
                let newString = searchString.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                self.gameDataHandler.loadListJSON("https://rawg-video-games-database.p.rapidapi.com/games?search=\(newString)")
                self.searchActive = true
                self.filterButton.isEnabled = false
            } else {
                self.setLoadingScreen() //Sets a loading screen while the API data loads
                self.gameDataHandler.clearGames()
                let topIndex = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: topIndex, at: .top, animated: true)
                self.gameDataHandler.onDataUpdate = {[weak self] (data:[Game]) in self?.render()}
                self.gameDataHandler.loadListJSON("https://rawg-video-games-database.p.rapidapi.com/games")
                self.pageNumber = 2
                self.searchActive = false
                self.filterButton.isEnabled = true
            }
            self.filterActive = false
        })
        searchAlert.addAction(searchItemAction)
        
        searchAlert.view.tintColor = .systemRed
        present(searchAlert, animated: true, completion: nil) //Present the alert to user
    }

    // MARK: - Table View
    
    //Function that returns the number of rows in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    //Set up the cells in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCellIdentifier", for: indexPath) as! TableViewCellController
        let game = games[indexPath.row]
        
        //Get the game image from the URL
        loadImage(fromURL: game.background_image ?? "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg", toImageView: cell.gameImageView)
        
        //Set the game name
        cell.titleLabel?.text = game.name
        
        //Platforms
//        for platform in game.platforms {
//            platformList.append((platform.platform?.name)!) //Add all of the game's platforma to the list
//        }
//        cell.platformLabel?.text = platformList.joined(separator: ", ")
//        platformList.removeAll() //Remove all the current platforms for the next game
        
        //Format the release date
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        if let date = dateFormatterGet.date(from: game.released ?? "0000-00-00") {
            cell.platformLabel?.text = dateFormatterPrint.string(from: date)
        } else {
            cell.platformLabel?.text = "-"
            print("Date string error")
        }
        
        //Genres
        for genre in game.genres {
            genreList.append(genre.name!) //Add all of the game's genres to the list
        }
        cell.genreLabel?.text = genreList.joined(separator: ", ")
        genreList.removeAll() //Remove all the current genres for the next game
        
        //Set a clear border to simulate space between cells
        cell.layer.borderWidth = CGFloat(5)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        cell.layer.cornerRadius = 25
        
        return cell
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
                    
                    //Add gradient fade effect to images
                    let gradientLayer = CAGradientLayer()
                    gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
                    gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
                    gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
                    gradientLayer.locations = [0, 0.5, 1]
                    gradientLayer.frame = imageView.bounds
                    imageView.layer.mask = gradientLayer
                }
            }
        }.resume()
    }
    
    //Function to load more data when the user reaches the end of the current set
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = games.count - 1
        if indexPath.row == lastElement && searchActive == true && filterActive == false{
            activityIndicator.isHidden = true //Hide the activity indicator
        } else if indexPath.row == lastElement && searchActive == false && filterActive == false{
            activityIndicator.isHidden = false //Show the activity indicator
            activityIndicator.startAnimating() //Start animating the activity indicator
            gameDataHandler.loadListJSON("https://api.rawg.io/api/games?page=\(pageNumber)") //Load the next page of data
            games.append(contentsOf: gameDataHandler.getGames()) //Add the data to the list
            pageNumber += 1 //Increment the page by 1
        } else if indexPath.row == lastElement && filterActive == true && searchActive == false{
            activityIndicator.isHidden = false //Show the activity indicator
            activityIndicator.startAnimating() //Start animating the activity indicator
            self.nextFilterURL = filterURL + "&page=\(filterPageNumber)"
            self.filterPageNumber += 1
            gameDataHandler.loadListJSON(self.nextFilterURL!) //Load the next page of data
            games.append(contentsOf: gameDataHandler.getGames()) //Add the data to the list
        }
    }
    
    //Function to get the list of games and reload the table view to populate the cells
    func render() {
        games = gameDataHandler.getGames() //Get the games
        removeLoadingScreen() //Remove the loading screen after the data has been loaded
        
        if self.gameDataHandler.JSONError() == true {
            searchError() //Throw an error
        } else {
            searchButton.isEnabled = true
            upButton.isEnabled = true
            filterButton.isEnabled = true
            tableView.reloadData() //Reload the table
        }
    }

    func searchError() {
        filterButton.isEnabled = true
        let errorAlert = UIAlertController(title: "Error", message: "Cannot find games with the provided search term.", preferredStyle: .alert)
        
        //Create add button
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: {(UIAlertAction) in
            self.setLoadingScreen() //Sets a loading screen while the API data loads
            self.gameDataHandler.clearGames()
            self.gameDataHandler.onDataUpdate = {[weak self] (data:[Game]) in self?.render()}
            self.gameDataHandler.loadListJSON("https://rawg-video-games-database.p.rapidapi.com/games")
            self.pageNumber = 2
            self.searchActive = false
        })
        errorAlert.addAction(okayAction)
        
        present(errorAlert, animated: true, completion: nil) //Present the alert to user
    }

    //Loading Screen from: https://stackoverflow.com/questions/29311093/place-activity-indicator-over-uitable-view
    //Function to display a loading screen while the data loads
    private func setLoadingScreen() {
        //Set up the view that contains the loading text and activity indicator
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
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
        tableView.addSubview(loadingView)
    }

    //Remove the loading screen
    private func removeLoadingScreen() {
        //Hides the text and stops the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
    }
    
    
    //Prepare to send data to the detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            if let detailVC = segue.destination as? DetailViewController { //Downcast the destination property to the DetailTableViewController
                if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!) {
                    //Sets the title and specific game slug data for the destination view controller
                    detailVC.title = games[indexPath.row].name
                    detailVC.selectedGameSlug = games[indexPath.row].slug!
                }
            }
        }
    }
    
    //Aoply filters to the full list
    @IBAction func unwindSegue (_ segue:UIStoryboardSegue) {
        //If the user clicks the Apply button
        if segue.identifier == "applySegue" {
            filterURL = "https://api.rawg.io/api/games?"
            
            //Modify the URL based on the chosen platform filter
            switch platformFilter {
                case "None":
                    filterURL += ""
                case "PC":
                    filterURL += "platforms=4,5,6"
                case "Xbox":
                    filterURL += "platforms=1,186,80,14"
                case "PlayStation":
                    filterURL += "platforms=187,18,16,15,27,19,17"
                case "Nintendo":
                    filterURL += "platforms=7,8,9,13,10,11,105,83,24,43,26,79,49"
                case "Mobile":
                    filterURL += "platforms=3,21"
                default:
                    filterURL += ""
            }
            //Modify the URL based on the chosen platform filter
            if platformFilter != "None" {
                switch genreFilter {
                    case "None":
                        filterURL += ""
                    case "Action":
                        filterURL += "&genres=4"
                    case "Indie":
                        filterURL += "&genres=51"
                    case "Adventure":
                        filterURL += "&genres=3"
                    case "RPG":
                        filterURL += "&genres=5"
                    case "Strategy":
                        filterURL += "&genres=10"
                    case "Shooter":
                        filterURL += "&genres=2"
                    case "Casual":
                        filterURL += "&genres=40"
                    case "Simulation":
                        filterURL += "&genres=14"
                    case "Puzzle":
                        filterURL += "&genres=7"
                    case "Arcade":
                        filterURL += "&genres=11"
                    case "Platformer":
                        filterURL += "&genres=83"
                    case "Racing":
                        filterURL += "&genres=1"
                    case "Sports":
                        filterURL += "&genres=15"
                    case "Multiplayer":
                        filterURL += "&genres=59"
                    case "Fighting":
                        filterURL += "&genres=6"
                    case "Family":
                        filterURL += "&genres=19"
                    case "Board Games":
                        filterURL += "&genres=28"
                    case "Educational":
                        filterURL += "&genres=34"
                    case "Card":
                        filterURL += "&genres=17"
                    default:
                        filterURL += ""
                }
            } else {
                switch genreFilter {
                case "None":
                    filterURL += ""
                case "Action":
                    filterURL += "genres=4"
                case "Indie":
                    filterURL += "genres=51"
                case "Adventure":
                    filterURL += "genres=3"
                case "RPG":
                    filterURL += "genres=5"
                case "Strategy":
                    filterURL += "genres=10"
                case "Shooter":
                    filterURL += "genres=2"
                case "Casual":
                    filterURL += "genres=40"
                case "Simulation":
                    filterURL += "genres=14"
                case "Puzzle":
                    filterURL += "genres=7"
                case "Arcade":
                    filterURL += "genres=11"
                case "Platformer":
                    filterURL += "genres=83"
                case "Racing":
                    filterURL += "genres=1"
                case "Sports":
                    filterURL += "genres=15"
                case "Multiplayer":
                    filterURL += "genres=59"
                case "Fighting":
                    filterURL += "genres=6"
                case "Family":
                    filterURL += "genres=19"
                case "Board Games":
                    filterURL += "genres=28"
                case "Educational":
                    filterURL += "genres=34"
                case "Card":
                    filterURL += "genres=17"
                default:
                    filterURL += ""
                }
            }
            self.searchActive = false //Set searchActive to false
            self.setLoadingScreen() //Sets a loading screen while the API data loads
            self.gameDataHandler.clearGames() //Clear the current list of games
            
            //If the platform and genre filter is "None", set filterActive to false
            if platformFilter == "None" && genreFilter == "None" {
                filterActive = false
            } else {
                self.filterPageNumber = 2 //Set the filter page number for the next page
                filterActive = true //Set filterActive to true
                
                //Scroll to the top of the screen
                let topIndex = IndexPath(row: 0, section: 0)
                tableView.scrollToRow(at: topIndex, at: .top, animated: true)
            }

            self.nextFilterURL = filterURL + "&page=\(filterPageNumber)" //Set the next page URL for the current filter URL
            
            //Load the filtered games into the table
            self.gameDataHandler.onDataUpdate = {[weak self] (data:[Game]) in self?.render()}
            self.gameDataHandler.loadListJSON(filterURL)
            
            //Print statements for debugging
//            print("filterURL \(filterURL!)")
//            print("nextfilterURL \(nextFilterURL!)")
//            print("number: \(filterPageNumber)")
        }
    }
    
    //Scroll to the top of the table when the up button is pressed
    @IBAction func upButton(_ sender: UIBarButtonItem) {
        let topIndex = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: topIndex, at: .top, animated: true)
    }
}
