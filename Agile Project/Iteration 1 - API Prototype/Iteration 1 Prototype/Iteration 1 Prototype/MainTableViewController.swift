//
//  MainTableViewController.swift
//  Iteration 1 Prototype
//
//  Created by Ryan Than on 2/21/21.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var games = [Game]()
    var rowHeight : CGFloat!
    var gameDataHandler = GameDataHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the row height for the table view
        //Help from: https://medium.com/better-programming/how-to-create-custom-uitableviewcell-f4e69193bab
        self.rowHeight = UIScreen.main.traitCollection.userInterfaceIdiom == .phone ? 152 : 75
        self.tableView.rowHeight = self.rowHeight
        
        gameDataHandler.onDataUpdate = {[weak self] (data:[Game]) in self?.render()}
        gameDataHandler.loadJSON("https://rawg-video-games-database.p.rapidapi.com/games")
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    //Set up the cells in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCellIdentifier", for: indexPath) as! TableViewCellController
        let game = games[indexPath.row]
        
        //Code to fill the entire cell with the image
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
//        imageView.contentMode = .scaleAspectFill
        
        //Get the game image from the URL
        //Got help from here: https://stackoverflow.com/questions/33356820/getting-image-from-url-for-uiview-swift
        if let url = URL(string: game.background_image) { //Set the image url
            let imagedata = try? Data(contentsOf: url) //Test if the url data is usable
            
            if let image = UIImage(data: imagedata!) { //Set the image
                cell.gameImageView?.image = image
//                imageView.image = image
            }
        }
        
//        cell.backgroundView = UIView()
//        cell.backgroundView!.addSubview(imageView)
        
        //Configure the cell
        cell.titleLabel?.text = game.name
        cell.platformLabel?.text = "Release Date: \(game.released)"
        cell.genreLabel?.text = "Metacritic Score: \(String(game.metacritic))"
        
        //Set a clear border to simulate space between cells
        cell.layer.borderWidth = CGFloat(5)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        cell.layer.cornerRadius = 25
        
        return cell
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        let lastElement = games.count - 1
//        if indexPath.row == lastElement {
//                gameDataHandler.onDataUpdate = {[weak self] (data:[Game]) in self?.render()}
//                gameDataHandler.loadJSON("https://api.rawg.io/api/games?page=2")
//            }
//    }
    
    //Function to get the list of games and reload the table view to populate the cells
    func render() {
        if games.isEmpty {
            games = gameDataHandler.getGames()
        } else {
            games.append(contentsOf: gameDataHandler.getGames())
        }
        tableView.reloadData()
    }

    
    //Prepare to send data to the detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            if let detailVC = segue.destination as? DetailViewController { //Downcast the destination property to the DetailTableViewController
                if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!) {
                    //Sets the title and specific game slug data for the destination view controller
                    detailVC.title = games[indexPath.row].name
                    detailVC.selectedGameSlug = games[indexPath.row].slug
                }
            }
        }
    }
}


/* Still Need To Finish:
 - Search
 - Filters
 - Get platforms/genres for each game
 - Darken image
 - Load more
 */
