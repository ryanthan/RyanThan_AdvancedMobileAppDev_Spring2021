//
//  ViewController.swift
//  Favorite Desserts
//
//  Created by Ryan Than on 2/14/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var dessertList = [String]()
    var subtitleList = [String]()
    var dessertData = DessertDataLoader()
    let dataFile = "dessert"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Get the data from the plist
        dessertData.loadData(filename: dataFile)
        dessertList = dessertData.getDesserts()
        subtitleList = dessertData.getSubtitles()
    }

    //Number of rows in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dessertList.count
    }
    
    //Displays table view cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Configure the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "dessertIdentifier", for: indexPath)
        cell.textLabel?.text = dessertList[indexPath.row] //Set the cell text
        cell.detailTextLabel?.text = subtitleList[indexPath.row] //Set the subtitle text
        return cell
    }
    
    //Prepare to send data to detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dessertSegue" {
            if let detailVC = segue.destination as? DetailTableViewController { //Downcast the destination property to the DetailTableViewController
                if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!) {
                    //Sets the title and data for the destination view controller
                    detailVC.title = dessertList[indexPath.row]
                    detailVC.dessertData = dessertData
                    detailVC.selectedDessert = indexPath.row
                }
            }
        }
    }
}
