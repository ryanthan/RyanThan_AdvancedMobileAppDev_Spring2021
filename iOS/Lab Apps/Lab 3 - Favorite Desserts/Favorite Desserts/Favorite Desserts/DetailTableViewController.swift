//
//  DetailTableViewController.swift
//  Favorite Desserts
//
//  Created by Ryan Than on 2/14/21.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var dessertData = DessertDataLoader()
    var selectedDessert = 0
    var dessertNameList = [String]()
    var searchController = UISearchController()
        
    //Use viewWillAppear for data that has changed or will change
    override func viewWillAppear(_ animated: Bool) {
        dessertNameList = dessertData.getNames(index: selectedDessert) //Add the dessert names to the list
        
        //Search Results
        let resultsController = SearchResultsController() //Create an instance of the SearchResultsController class
        resultsController.alldesserts = dessertNameList //Set the dessertNameList property to our dessert name array
        searchController = UISearchController(searchResultsController: resultsController) //Initialize our search controller with the resultsController when it has search results to display
        
        //Search bar configuration
        searchController.searchBar.placeholder = "Enter a search term" //Placeholder text
        searchController.searchBar.sizeToFit() //Sets appropriate size for the search bar
        tableView.tableHeaderView = searchController.searchBar //Install the search bar as the table header
        
        searchController.searchResultsUpdater = resultsController //Sets the instance to update search results
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dessertNameList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dessertIdentifier", for: indexPath)

        // Configure the cell
        cell.textLabel?.text = dessertNameList[indexPath.row] //Update the cell text with the dessert name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Row selected", message: "Yum! \(dessertNameList[indexPath.row]) \(self.title!.lowercased()) is the best!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true) //Deselects the row that had been chosen
    }

    //Override function to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    //Override function to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Delete the dessert from the array
            dessertNameList.remove(at: indexPath.row)
            //Delete the row from the table
            tableView.deleteRows(at: [indexPath], with: .fade)
            //Delete from the data model instance
            dessertData.deleteDessert(index: selectedDessert, dessertIndex: indexPath.row)
        } else if editingStyle == .insert {
            //Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    //Override function to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let fromRow = fromIndexPath.row //Row being moved from
        let toRow = to.row //Row being moved to
        let moveDessert = dessertNameList[fromRow] //Dessert being moved
        //Swap positions in array
        dessertNameList.swapAt(fromRow, toRow)
        //Move in data model instance
        dessertData.deleteDessert(index: selectedDessert, dessertIndex: fromRow)
        dessertData.addDessert(index: selectedDessert, newDessert: moveDessert, newIndex: toRow)
    }
    
    //Prepare to send data to add dessert view controller
    //Used to programmatically set the label
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            if let detailVC = segue.destination as? AddDessertViewController { //Downcast the destination property to the AddDessertViewController
                detailVC.title = self.title
            }
        }
    }
    
    //Function to add a dessert to the list by getting data from the AddDessertViewController
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        if segue.identifier == "saveSegue" {
            if let source = segue.source as? AddDessertViewController {
                //Only add a dessert if there is text in the textfield
                if source.addedDessert.isEmpty == false{
                    //Add the new dessert to our data model instance
                    dessertData.addDessert(index: selectedDessert, newDessert: source.addedDessert, newIndex: dessertNameList.count)
                    //Add the new dessert to the array
                    dessertNameList.append(source.addedDessert)
                    tableView.reloadData()
                }
            }
        }
    }
}
