//
//  ViewController.swift
//  Pokemon Trainer Info
//
//  Created by Ryan Than on 2/3/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var gamePicker: UIPickerView!
    @IBOutlet weak var gameLabel: UILabel!
    
    var gameData = DataLoader()
    var generations = [String]()
    var games = [String]()
    let generationComponent = 0
    let gameComponent = 1
    let filename = "pokemongames"
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == generationComponent {
            return generations.count
        } else {
            return games.count
        }
    }
    
    //Picker Delegate Methods
    //Function that returns the title for a given row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Checks which component was picked and returns the value for the requested component
        if component == generationComponent {
            return generations[row]
        } else {
            return games[row]
        }
    }
    
    //Called when row is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Checks which component was picked
        if component == generationComponent {
            games = gameData.getGames(index: row) //Gets games for the selected generation
            gamePicker.reloadComponent(gameComponent) //Reload the generation component
            gamePicker.selectRow(0, inComponent: gameComponent, animated: true) //Set the generation component back to 0
        }
        let generationRow = pickerView.selectedRow(inComponent: generationComponent) //Gets the selected row for the generation
        let gameRow = pickerView.selectedRow(inComponent: gameComponent) //Gets the selected row for the game
        gameLabel.text = "Your favorite Pokemon game is: \(games[gameRow]) from \(generations[generationRow])."
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        gameData.loadData(filename: filename)
        generations = gameData.getGenerations()
        games = gameData.getGames(index: 0)
    }


}

