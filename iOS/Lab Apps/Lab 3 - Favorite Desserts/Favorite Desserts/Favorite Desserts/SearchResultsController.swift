//
//  SearchResultsController.swift
//  Favorite Desserts
//
//  Created by Ryan Than on 2/14/21.
//

import UIKit

//Controls the search results
class SearchResultsController: UITableViewController, UISearchResultsUpdating {
    
    var alldesserts = [String]()
    var filteredDesserts = [String]()
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text //Search string text
                filteredDesserts.removeAll(keepingCapacity: true) //Removes all elements in the filtered dessert names array
        if searchString?.isEmpty == false { //If there is some text in the search bar
                    //Closure that will be called for each dessert name to see if it matches the search string
                    let searchfilter: (String) -> Bool = { name in
                        //Look for the search string as a substring of the dessert name
                        let range = name.range(of: searchString!, options: .caseInsensitive)
                        return range != nil //Returns true if the value matches and false if there’s no match
                    } //End of closure
                    //Add the matches to the filtered desserts array
                    let matches = alldesserts.filter(searchfilter)
                    filteredDesserts.append(contentsOf: matches)
                }
                tableView.reloadData() //Reload table data with the search results
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "dessertIdentifier") //Register our table cell identifier
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDesserts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dessertIdentifier", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = filteredDesserts[indexPath.row] //Update the cell text

        return cell
    }
}
