//
//  SearchResultsController.swift
//  scrabbleQ
//
//  Created by Ryan Than on 2/8/21.
//

import UIKit

class SearchResultsController: UITableViewController, UISearchResultsUpdating {
    
    var allwords = [String]()
    var filteredWords = [String]()
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text //Search string text
                filteredWords.removeAll(keepingCapacity: true) //Removes all elements in the filtered words array
        if searchString?.isEmpty == false { //If there is some text in the search bar
                    //Closure that will be called for each word to see if it matches the search string
                    let searchfilter: (String) -> Bool = { name in
                        //Look for the search string as a substring of the word
                        let range = name.range(of: searchString!, options: .caseInsensitive)
                        return range != nil //Returns true if the value matches and false if there’s no match
                    } //End of closure
                    //Add the matches to the filtered words array
                    let matches = allwords.filter(searchfilter)
                    filteredWords.append(contentsOf: matches)
                }
                tableView.reloadData() //Reload table data with the search results
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "scrabbleIdentifier") //Register our table cell identifier
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scrabbleIdentifier", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = filteredWords[indexPath.row] //Update the cell text

        return cell
    }

    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Row selected", message: "You selected \(filteredWords[indexPath.row])", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true) //Deselects the row that had been chosen
    }
}
