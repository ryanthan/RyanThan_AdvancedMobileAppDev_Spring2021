//
//  SearchResultsController.swift
//  Ludos
//
//  Created by Ryan Than on 3/26/21.
//

import UIKit

class SearchResultsController: UITableViewController, UISearchResultsUpdating {
    
    //Variables
    var allGames = [Favorite]()
    var filteredGames = [Favorite]()
    
    //Function that is called when the view is first loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favoriteGameIdentifier") //Register the cell reuse identifier
    }
    
    //Search function
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text //Search string
        filteredGames.removeAll(keepingCapacity: true) //Removes all elements
        if searchString?.isEmpty == false { //If the search bar is not empty:
            //Closure that is called for each game name to see if it matches the search string
            let searchfilter: (Favorite) -> Bool = { game in
                //Look for the search string as a substring of the game name
                let range = game.name!.range(of: searchString!, options: .caseInsensitive)
                return range != nil //Returns true if the value matches and false if there’s no match
            } //End closure
            
            //Add the filtered games to the list
            let matches = allGames.filter(searchfilter)
            filteredGames.append(contentsOf: matches)
        }
        tableView.reloadData() //Reload the table with the search results
    }

    //Number of sections in the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Number of rows in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGames.count
    }

    //Fill in the cell content
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteGameIdentifier", for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = filteredGames[indexPath.row].name
        
        //Get the game image from the URL
        if let url = URL(string: filteredGames[indexPath.row].background_image ?? "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg") { //Set the image url
            let imagedata = try? Data(contentsOf: url) //Test if the url data is usable

            if let image = UIImage(data: imagedata!) { //Set the image
                cell.imageView!.image = image
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Row selected", message: "You selected \(filteredWords[indexPath.row])", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler:
    nil)
    row that had been chosen
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil) tableView.deselectRow(at: indexPath, animated: true) //deselects the
    }
}
