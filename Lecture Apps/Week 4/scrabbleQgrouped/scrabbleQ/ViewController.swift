//
//  ViewController.swift
//  scrabbleQ
//
//  Created by Aileen Pierce
//

import UIKit

class ViewController: UITableViewController {
    
    var words = [GroupedWords]()
    var letters = [String]()
    var data = DataLoader()
    let wordFile = "qwordswithoutu3"
    var searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Load the data
        data.loadData(filename: wordFile)
        //Get words
        words = data.getWords()
        //Get letters
        letters = data.getLetters()
        
        //Search results
        let resultsController = SearchResultsController() //create an instance of our SearchResultsController class
        resultsController.allwords = words
        searchController = UISearchController(searchResultsController: resultsController) //create a search controller and initialize with our SearchResultsController instance
        
        //Search bar configuration
        searchController.searchBar.placeholder = "Enter a search term" //place holder text
        //searchController.searchBar.sizeToFit() //sets appropriate size for the search bar
        tableView.tableHeaderView=searchController.searchBar //install the search bar as the table header
        searchController.searchResultsUpdater = resultsController //sets the instance to update search results
    }

    //Required methods for UITableViewDataSource
    //Customize the number of rows in the section, will be called for each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        words[section].words.count
    }
    
    //Displays table view cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeues an existing cell if one is available, or creates a new one and adds it to the table
        let section = indexPath.section
        let wordsSection = words[section].words
        //Configure the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "scrabbleIdentifier", for: indexPath)
        cell.textLabel?.text = wordsSection[indexPath.row]
        return cell
    }
    
    //UITableViewDelegate method that is called when a row is selected (presents an alert)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let wordsSection = words[section].words
        let alert = UIAlertController(title: "Row selected", message: "You selected \(wordsSection[indexPath.row])", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true) //deselects the row that had been chosen
    }
    
    //Function that adds a header view for each section
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerview = view as! UITableViewHeaderFooterView
        headerview.textLabel?.font = UIFont(name: "Helvetica", size: 20) //Change the font
        headerview.textLabel?.textAlignment = .center //Center the header
    }
    
    //Return the number of sections (in this case, it is based on how many letters there are)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return letters.count
    }
    
    //Return the headers (letters) for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //tableView.headerView(forSection: section)?.textLabel?.textAlignment = NSTextAlignment.center //Can center the header here or in the other function
        return letters[section]
    }
    
    //Puts the section headers on the side
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return letters
    }

    //Function to customize the header/footer
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UITableViewHeaderFooterView()
        var myView:UIImageView
        if section == 0 {
            myView = UIImageView(frame: CGRect(x: 10, y: 8, width: 40, height: 40))
        } else {
            myView = UIImageView(frame: CGRect(x: 10, y: -10, width: 40, height: 40))
        }
        let myImage = UIImage(named: "scrabble_q_tile")
        myView.image = myImage
        headerview.addSubview(myView)
        return headerview
    }
}

