//
//  FavoritesViewController.swift
//  Iteration 2 Prototype
//
//  Created by Ryan Than on 3/17/21.
//

import UIKit

class FavoritesViewController: UITableViewController {
    
    //Variables
    var favoritesData = FavoritesDataHandler()
    let dataFile = "favoritesList.plist"
    var favoritesList = [Favorite]()
    
    //Function that runs when the view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the Edit button on the left of the navigation bar
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //application instance
        let app = UIApplication.shared
        //subscribe to the UIApplicationWillResignActiveNotification notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: app)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoritesData.loadData(fileName: dataFile)
        favoritesList = favoritesData.getItems()
        DispatchQueue.main.async { self.tableView.reloadData() }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteGameIdentifier", for: indexPath)
        let game = favoritesList[indexPath.row]
        
        //Get the game image from the URL
        if let url = URL(string: game.background_image ?? "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg") { //Set the image url
            let imagedata = try? Data(contentsOf: url) //Test if the url data is usable

            if let image = UIImage(data: imagedata!) { //Set the image
                cell.imageView!.image = image
            }
        }
        
        //Set the game name
        cell.textLabel!.text = game.name
        
        //Format the release date and set it into the label
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        if let date = dateFormatterGet.date(from: game.released ?? "0000-00-00") {
            cell.detailTextLabel?.text = "Release Date: \(dateFormatterPrint.string(from: date))"
        } else {
           print("Date string error")
        }
        
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
            favoritesList.remove(at: indexPath.row)
            favoritesData.deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            favoritesData.saveData(fileName: dataFile)
        }
    }
    
    //Prepare to send data to the detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailVC = segue.destination as? DetailViewController { //Downcast the destination property to the DetailTableViewController
                if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!) {
                    //Sets the title and specific game slug data for the destination view controller
                    detailVC.title = favoritesList[indexPath.row].name
                    detailVC.selectedGameSlug = favoritesList[indexPath.row].slug!
                }
            }
        }
    }
}
