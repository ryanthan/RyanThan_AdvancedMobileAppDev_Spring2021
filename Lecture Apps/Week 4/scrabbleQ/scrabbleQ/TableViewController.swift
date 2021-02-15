//
//  TableViewController.swift
//  scrabbleQ
//
//  Created by Ryan Than on 2/8/21.
//

import UIKit

class TableViewController: UITableViewController {

    var words = [String]()
    var data = DataLoader()
    let wordFile = "qwordswithoutu1"
    var searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data.loadData(filename: wordFile) //Load the data from the plist
        words = data.getWords() //Get words

        //Search Results
        let resultsController = SearchResultsController() //Create an instance of our SearchResultsController class
        resultsController.allwords = words //Set the allwords property to our words array
        searchController = UISearchController(searchResultsController: resultsController) //Initialize our search controller with the resultsController when it has search results to display
        
        //Search bar configuration (optional)
        searchController.searchBar.placeholder = "Enter a search term" //Placeholder text
        searchController.searchBar.sizeToFit() //Sets appropriate size for the search bar
        tableView.tableHeaderView=searchController.searchBar //Install the search bar as the table header
        
        searchController.searchResultsUpdater = resultsController //Sets the instance to update search results
    }

    // MARK: - Table view data source
    
    //Function that returns the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //The default number of sections is 1 so we don't really need this function
    }
    
    //Function that returns the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count //Return how many items are in the table
    }

    //Function to draw the table rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scrabbleIdentifier", for: indexPath)

        //Configure the cell:
        cell.textLabel?.text = words[indexPath.row] //Set the text for each cell
        //cell.imageView?.image = UIImage(named: "scrabble_q_tile.png") //Adding the image for each cell programatically
        return cell //Return the cell
    }
    
    // MARK: - Navigation
    
    //Function gets called whenever the user taps on the row (in this case, display an alert)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Row selected", message: "You selected \(words[indexPath.row])", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true) //Deselects the row that had been chosen
    }
}
