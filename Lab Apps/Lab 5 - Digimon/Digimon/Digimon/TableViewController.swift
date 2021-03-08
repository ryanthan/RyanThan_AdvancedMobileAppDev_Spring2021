//
//  TableViewController.swift
//  Digimon
//
//  Created by Ryan Than on 3/7/21.
//

import UIKit

class TableViewController: UITableViewController {
    var digimonList = [Digimon]() //List to store Digimon data
    var digimonDataHandler = DigimonDataHandler() //Create instance of data handler
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load API data
        digimonDataHandler.onDataUpdate = {[weak self] (data:[Digimon]) in self?.render()}
        digimonDataHandler.loadJSON()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return digimonList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)

        //Configure the cell
        let digimon = digimonList[indexPath.row]
        cell.textLabel!.text = digimon.name //Set the digimon name
        cell.detailTextLabel!.text = digimon.level //Set the digimon level in the subtitle
        
        if let url = URL(string: digimon.img) { //Set the image url
            let imagedata = try? Data(contentsOf: url) //Test if the url data is usable
            
            if let image = UIImage(data: imagedata!) {
                cell.imageView?.layer.masksToBounds = true
                cell.imageView?.layer.cornerRadius = 20
                cell.imageView!.image = image //Set the image
            }
        }
        
        //Set a clear border to simulate space between cells
        cell.layer.borderWidth = CGFloat(1)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        cell.layer.cornerRadius = 20
        
        return cell
    }
    
    //Get all of the Digimon data, add it to the array, and reload the table
    func render() {
        digimonList = digimonDataHandler.getDigimonList()
        tableView.reloadData()
    }
}
