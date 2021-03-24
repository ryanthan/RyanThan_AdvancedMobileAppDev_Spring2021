//
//  PrimaryTableViewController.swift
//  Landscape Details
//
//  Created by Ryan Than on 2/17/21.
//

import UIKit

class PrimaryTableViewController: UITableViewController {

    //Variables
    var locations = [String]()
    var locationData = DataHandler()
    let fileName = "landscapeDetails"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the data from the plist
        locationData.loadData(fileName: fileName)
        locations = locationData.getLocations()
    }

    // MARK: - Table View Functions

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel!.text = locations[indexPath.row]

        return cell
    }
    
    //Prepare to send data to the secondary view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SecondarySegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let url = locationData.getURL(index: indexPath.row)
                let name = locations[indexPath.row]
                let detailVC = (segue.destination as! UINavigationController).topViewController as! SecondaryViewController
                detailVC.webpage = url
                detailVC.title = name
            }
        }
    }
}
