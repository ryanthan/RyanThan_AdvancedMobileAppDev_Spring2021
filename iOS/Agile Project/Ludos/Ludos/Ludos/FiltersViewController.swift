//
//  FiltersViewController.swift
//  Ludos
//
//  Created by Ryan Than on 3/25/21.
//

import UIKit

class FiltersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Variables & Connections:
    @IBOutlet weak var filterPicker: UIPickerView!
    @IBOutlet weak var filterStatementLabel: UILabel!
    let platforms = ["None", "PC", "Xbox", "PlayStation", "Nintendo", "Mobile"]
    let genres = ["None", "Action", "Indie", "Adventure", "RPG", "Strategy", "Shooter", "Casual", "Simulation", "Puzzle", "Arcade", "Platformer", "Racing", "Sports", "Multiplayer", "Fighting", "Family", "Board Games", "Educational", "Card"]
    var platformRow : String?
    var genreRow : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        filterStatementLabel.text = "Return to the full list." //Set the initial filter label text
    }
    
    //Picker Methods:
    //Return number of picker components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //Returns the number of elements in each picker component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return platforms.count
        } else {
            return genres.count
        }
    }

    //Returns the title for a given picker row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return platforms[row]
        } else {
            return genres[row]
        }
    }
    
    //Called when a row is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Set the platform and genre row variables
        platformRow = platforms[pickerView.selectedRow(inComponent: 0)]
        genreRow = genres[pickerView.selectedRow(inComponent: 1)]
        
        //Set the filter label text
        if platformRow == "None" && genreRow == "None" {
            filterStatementLabel.text = "Return to the full list."
        } else if platformRow == "None" {
            filterStatementLabel.text = "You are looking for \(genreRow ?? "[genre]") games on any platform."
        } else if genreRow == "None" {
            filterStatementLabel.text = "You are looking for all games on \(platformRow ?? "[platform]")."
        } else {
            filterStatementLabel.text = "You are looking for \(genreRow ?? "[genre]") games on \(platformRow ?? "[platform]")."
        }
    }
    
    
    //Prepare to send data to the main table view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "applySegue" {
            if let mainTableVC = segue.destination as? MainTableViewController { //Downcast the destination property to the DetailTableViewController
                mainTableVC.platformFilter = platformRow ?? "None"
                mainTableVC.genreFilter = genreRow ?? "None"
            }
        }
    }
}
