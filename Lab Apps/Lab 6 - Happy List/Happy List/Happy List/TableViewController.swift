//
//  TableViewController.swift
//  Happy List
//
//  Created by Ryan Than on 3/10/21.
//

import UIKit

class TableViewController: UITableViewController {
    
    //Variables
    var items = [String]()
    var itemData = ItemDataHandler()
    let dataFile = "happyitems.plist"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the Edit button on the left of the navigation bar
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //Load the data from the file
        itemData.loadData(fileName: dataFile)
        items = itemData.getItems()
        
        //Application instance
        let app = UIApplication.shared
        //Subscribe to the UIApplicationWillResignActiveNotification notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: app)
    }
    
    //Function to save the data to the p-list
    //Called when the UIApplicationWillResignActiveNotification notification is posted
    @objc func applicationWillResignActive(_ notification: Notification){
        itemData.saveData(fileName: dataFile)
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let addalert = UIAlertController(title: "New Item", message: "What makes you happy?", preferredStyle: .alert)
        addalert.addTextField(configurationHandler: {(UITextField) in}) //Add textfield to the alert
        
        //Create cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addalert.addAction(cancelAction)
        
        //Create add button
        let addItemAction = UIAlertAction(title: "Add", style: .default, handler: {(UIAlertAction) in
            //Adds new item to the table
            let newItemTextField = addalert.textFields![0] //Gets textfield
            let newItem = newItemTextField.text! //Gets text in the textfield
            self.items.append(newItem) //Adds textfield text to array
            self.tableView.reloadData() //Reload the table with the new data
            self.itemData.addItem(newItem: newItem) //Add item to data handler
        })
        addalert.addAction(addItemAction)
        
        present(addalert, animated: true, completion: nil) //Present the alert to user
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    //Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: indexPath.row)
            itemData.deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //Function to show a simple alert when a table item is pressed
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addalert = UIAlertController(title: "\(items[indexPath.row]) makes me happy!", message: "Happiness is whatever you want it to be!", preferredStyle: .alert)
        
        //Create cancel button
        let cancelAction = UIAlertAction(title: "Yes!", style: .cancel, handler: nil)
        addalert.addAction(cancelAction)
        
        present(addalert, animated: true, completion: nil) //Present the alert to user
    }
}
