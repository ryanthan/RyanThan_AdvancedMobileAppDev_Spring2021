//
//  MainTableViewController.swift
//  Iteration 2 Prototype
//
//  Created by Ryan Than on 2/21/21.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    //Variables
    var games = [Game]()
    var rowHeight : CGFloat!
    var gameDataHandler = GameDataHandler()
    var genreList = [String]()
    var platformList = [String]()
    var pageNumber = 2
    var searchActive = false
    
    //Activity indicator
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Function that runs when the view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadingScreen() //Sets a loading screen while the API data loads
        activityIndicator.isHidden = true //Hide the activity indicator at first
        
        //Set the row height for the table view
        //Help from: https://medium.com/better-programming/how-to-create-custom-uitableviewcell-f4e69193bab
        self.rowHeight = UIScreen.main.traitCollection.userInterfaceIdiom == .phone ? 152 : 75
        self.tableView.rowHeight = self.rowHeight
        
        //Get the first set of data from the API
        gameDataHandler.onDataUpdate = {[weak self] (data:[Game]) in self?.render()}
        gameDataHandler.loadListJSON("https://rawg-video-games-database.p.rapidapi.com/games")
    }
    
    @IBAction func SearchButton(_ sender: UIBarButtonItem) {
        let addalert = UIAlertController(title: "Search", message: "Please enter a search term. Leave blank to return to the full list.", preferredStyle: .alert)
        addalert.addTextField(configurationHandler: {(UITextField) in}) //Add textfield to the alert
        
        //Create cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addalert.addAction(cancelAction)
        
        //Create add button
        let addItemAction = UIAlertAction(title: "Search", style: .default, handler: {(UIAlertAction) in
            let searchTextField = addalert.textFields![0] //Gets textfield
            let searchString = searchTextField.text! //Gets text in the textfield
            
            if searchString.isEmpty == false {
                self.setLoadingScreen() //Sets a loading screen while the API data loads
                self.gameDataHandler.clearGames()
                self.gameDataHandler.onDataUpdate = {[weak self] (data:[Game]) in self?.render()}
                let newString = searchString.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                self.gameDataHandler.loadListJSON("https://rawg-video-games-database.p.rapidapi.com/games?search=\(newString)")
                self.searchActive = true
            } else {
                self.setLoadingScreen() //Sets a loading screen while the API data loads
                self.gameDataHandler.clearGames()
                self.gameDataHandler.onDataUpdate = {[weak self] (data:[Game]) in self?.render()}
                self.gameDataHandler.loadListJSON("https://rawg-video-games-database.p.rapidapi.com/games")
                self.pageNumber = 2
                self.searchActive = false
            }
        })
        addalert.addAction(addItemAction)
        
        present(addalert, animated: true, completion: nil) //Present the alert to user
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
        
        //Genres
        for platform in game.platforms {
            platformList.append((platform.platform?.name)!) //Add all of the game's platforma to the list
        }
        cell.platformLabel?.text = platformList.joined(separator: ", ")
        platformList.removeAll() //Remove all the current platforms for the next game
        
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
                }
            }
        }.resume()
    }
    
    //Function to load more data when the user reaches the end of the current set
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = games.count - 1
        if indexPath.row == lastElement && searchActive == false {
            activityIndicator.isHidden = false //Show the activity indicator
            activityIndicator.startAnimating() //Start animating the activity indicator
            gameDataHandler.loadListJSON("https://api.rawg.io/api/games?page=\(pageNumber)") //Load the next page of data
            games.append(contentsOf: gameDataHandler.getGames()) //Add the data to the list
            pageNumber += 1 //Increment the page by 1
        }
    }
    
    //Function to get the list of games and reload the table view to populate the cells
    func render() {
        games = gameDataHandler.getGames() //Get the games
        removeLoadingScreen() //Remove the loading screen after the data has been loaded
        
        if self.gameDataHandler.JSONError() == true {
            searchError()
        } else if self.gameDataHandler.JSONError() == false && searchActive == true{
            let topIndex = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: topIndex, at: .top, animated: true)
            tableView.reloadData() //Reload the table
        } else {
            tableView.reloadData() //Reload the table
        }
    }

    func searchError() {
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
    private func setLoadingScreen() {
        //Set up the view that contains the loading text and activity indicator
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        //Configure the loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        loadingLabel.isHidden = false

        //Configure the activity indicator
        spinner.style = .medium
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()

        //Adds the text and activity indicator to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)

        //Present the view
        tableView.addSubview(loadingView)
    }

    //Remove the activity indicator from the main view
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
}

//Got help from here: https://stackoverflow.com/questions/33356820/getting-image-from-url-for-uiview-swift
//        if let url = URL(string: game.background_image!) { //Set the image url
//            let imagedata = try? Data(contentsOf: url) //Test if the url data is usable
//
//            if let image = UIImage(data: imagedata!) { //Set the image
//                cell.gameImageView?.image = image
//            }
//        }
