//
//  FavoritesViewController.swift
//  Ludos
//
//  Created by Ryan Than on 3/25/21.
//

import UIKit

class FavoritesViewController: UITableViewController {
    
    //Variables:
    var favoritesData = FavoritesDataHandler()
    let dataFile = "favoritesList.plist"
    var favoritesList = [Favorite]()
    let function = CommonFunctions()
    @IBOutlet weak var emptyLabel: UILabel!
    
    //Function that runs when the view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark //Set the interface style to dark mode
        
        //Set the Edit button on the left of the navigation bar
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //Subscribe to the UIApplicationWillResignActiveNotification notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    //Function that is called every time the view is loaded
    override func viewWillAppear(_ animated: Bool) {
        //Get favorites data
        favoritesData.loadData(fileName: dataFile)
        favoritesList = favoritesData.getItems()
        DispatchQueue.main.async { self.tableView.reloadData() }
        
        //Check if the favorites list is empty or not
        if favoritesList.isEmpty == true {
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            emptyLabel.isHidden = false
        } else {
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            emptyLabel.isHidden = true
        }
    }
    
    //Save data when the UIApplicationWillResignActiveNotification notification is posted
    @objc func applicationWillResignActive(_ notification: Notification){
        favoritesData.saveData(fileName: dataFile)
    }

    // MARK: - Table View
    
    //Function that returns the number of rows in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesList.count
    }
    
    //Set up the cells in the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteGameIdentifier", for: indexPath) as! FavoriteTableViewCellController
        let game = favoritesList[indexPath.row]
        
        //Get the game image from the URL
        function.loadImageGradient(fromURL: game.background_image ?? "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg", toImageView: cell.favoriteImageView)
        
        //Set the game name
        cell.favoriteGameTitleLabel.text = game.name
        
        //Set a clear border to simulate space between cells
        cell.layer.borderWidth = CGFloat(5)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        cell.layer.cornerRadius = 25
        
        return cell
    }
    
    //Override to support conditional editing of the table view
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Editing the table view
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            favoritesList.remove(at: indexPath.row)
            favoritesData.deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            favoritesData.saveData(fileName: dataFile)
            
            //If the list is empty, disable editing and display label
            if favoritesList.isEmpty == true {
                self.navigationItem.leftBarButtonItem?.isEnabled = false
                emptyLabel.isHidden = false
            }
        }
    }
    
    //Override to support manual reordering of the table view
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Reordering the table view
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = favoritesList[sourceIndexPath.row]
        favoritesList.remove(at: sourceIndexPath.row)
        favoritesData.deleteItem(index: sourceIndexPath.row)
        
        favoritesList.insert(itemToMove, at: destinationIndexPath.row)
        favoritesData.insertItem(newItem: itemToMove, index: destinationIndexPath.row)
        
        favoritesData.saveData(fileName: dataFile)
    }
    
    
    // MARK: - Segue Functions
    
    //Prepare to send data to the detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailVC = segue.destination as? DetailViewController { //Downcast the destination property to the DetailViewController
                if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!) {
                    //Sets the title, game slug, and randomOn data for the destination view controller
                    detailVC.title = favoritesList[indexPath.row].name
                    detailVC.selectedGameSlug = favoritesList[indexPath.row].slug!
                    detailVC.randomOn = false
                }
            }
        }
    }
}
