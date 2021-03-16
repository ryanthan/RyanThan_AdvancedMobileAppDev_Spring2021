//
//  SearchResultsController.swift
//  Iteration 2 Prototype
//
//  Created by Ryan Than on 3/15/21.
//

import UIKit

class SearchResultsController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var filteredGames = [Game]()
    var rowHeight : CGFloat!
    var gameDataHandler = GameDataHandler()
    var genreList = [String]()
    var platformList = [String]()
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text //search string
        filteredGames.removeAll(keepingCapacity: true) //removes all elements
        if searchString?.isEmpty == false {
            gameDataHandler.onDataUpdate = {[weak self] (data:[Game]) in self?.render()}
            gameDataHandler.loadListJSON("https://rawg-video-games-database.p.rapidapi.com/games?search=\(searchString ?? "")")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the row height for the table view
        //Help from: https://medium.com/better-programming/how-to-create-custom-uitableviewcell-f4e69193bab
        self.rowHeight = UIScreen.main.traitCollection.userInterfaceIdiom == .phone ? 152 : 75
        self.tableView.rowHeight = self.rowHeight
        
        //Register our table cell identifier
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "gameCellIdentifier")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGames.count
    }
    
    //Set up the cells in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCellIdentifier", for: indexPath)
        let game = filteredGames[indexPath.row]
        
        //Get the game image from the URL
        //Got help from here: https://stackoverflow.com/questions/33356820/getting-image-from-url-for-uiview-swift
        if let url = URL(string: game.background_image!) { //Set the image url
            let imagedata = try? Data(contentsOf: url) //Test if the url data is usable
            
            if let image = UIImage(data: imagedata!) { //Set the image
//                cell.gameImageView?.image = image
                cell.imageView?.image = image
            }
        }
        
        //Configure the cell
//        cell.titleLabel?.text = game.name
        cell.textLabel?.text = game.name
        
        //Genres
//        for platform in game.platforms {
//            platformList.append((platform.platform?.name)!) //Add all of the game's platforma to the list
//        }
//        cell.platformLabel?.text = platformList.joined(separator: ", ")
//        platformList.removeAll() //Remove all the current platforms for the next game
//
//        //Genres
//        for genre in game.genres {
//            genreList.append(genre.name!) //Add all of the game's genres to the list
//        }
//        cell.genreLabel?.text = genreList.joined(separator: ", ")
//        genreList.removeAll() //Remove all the current genres for the next game
        
        //Set a clear border to simulate space between cells
        cell.layer.borderWidth = CGFloat(5)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        cell.layer.cornerRadius = 25
        
        return cell
    }

    //Function to get the list of games and reload the table view to populate the cells
    func render() {
        if filteredGames.isEmpty {
            filteredGames = gameDataHandler.getGames()
        } else {
            filteredGames.append(contentsOf: gameDataHandler.getGames())
        }
        tableView.reloadData()
    }

    
    //Prepare to send data to the detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            if let detailVC = segue.destination as? DetailViewController { //Downcast the destination property to the DetailTableViewController
                if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!) {
                    //Sets the title and specific game slug data for the destination view controller
                    detailVC.title = filteredGames[indexPath.row].name
                    detailVC.selectedGameSlug = filteredGames[indexPath.row].slug!
                }
            }
        }
    }
}
