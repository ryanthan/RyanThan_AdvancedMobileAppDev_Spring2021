//
//  FavoritesViewController.swift
//  Ludos
//
//  Created by Ryan Than on 3/25/21.
//

import UIKit

class FavoritesViewController: UITableViewController {
    
    //Variables
    var favoritesData = FavoritesDataHandler()
    let dataFile = "favoritesList.plist"
    var favoritesList = [Favorite]()
    @IBOutlet weak var emptyLabel: UILabel!
    
    //Function that runs when the view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        //Set the Edit button on the left of the navigation bar
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //application instance
        let app = UIApplication.shared
        //subscribe to the UIApplicationWillResignActiveNotification notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: app)
    }
    
    //Function that is called when the view will appear
    override func viewWillAppear(_ animated: Bool) {
        favoritesData.loadData(fileName: dataFile)
        favoritesList = favoritesData.getItems()
        DispatchQueue.main.async { self.tableView.reloadData() }
        
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
        loadImage(fromURL: game.background_image ?? "https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg", toImageView: cell.favoriteImageView)
        
        //Set the game name
        cell.favoriteGameTitleLabel.text = game.name
        
        //Set a clear border to simulate space between cells
        cell.layer.borderWidth = CGFloat(5)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        cell.layer.cornerRadius = 25
        
        return cell
    }
    
    //Function to quickly grab images from the URL
    func loadImage(fromURL urlString: String, toImageView imageView: UIImageView) {
        //If the URL is null, return
        guard let url = URL(string: urlString) else {
            return
        }

        //Add an activity indicator to the center of each imageView
        let activityView = UIActivityIndicatorView(style: .large)
        imageView.addSubview(activityView)
        activityView.frame = imageView.bounds
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        activityView.startAnimating()

        //Get the image from the URL
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //Stop the activity indicator and remove it
            DispatchQueue.main.async {
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            }
            
            //Update the image view if the data was successfully downloaded
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    imageView.image = image
                    
                    //Add gradient fade effect to images
                    let gradientLayer = CAGradientLayer()
                    gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
                    gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
                    gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
                    gradientLayer.locations = [0, 0.5, 1]
                    gradientLayer.frame = imageView.bounds
                    imageView.layer.mask = gradientLayer
                }
            }
        }.resume()
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
            
            if favoritesList.isEmpty == true {
                self.navigationItem.leftBarButtonItem?.isEnabled = false
                emptyLabel.isHidden = false
            }
        }
        favoritesData.saveData(fileName: dataFile)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = favoritesList[sourceIndexPath.row]
        favoritesList.remove(at: sourceIndexPath.row)
        favoritesData.deleteItem(index: sourceIndexPath.row)
        favoritesList.insert(itemToMove, at: destinationIndexPath.row)
        favoritesData.insertItem(newItem: itemToMove, index: destinationIndexPath.row)
        favoritesData.saveData(fileName: dataFile)
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
