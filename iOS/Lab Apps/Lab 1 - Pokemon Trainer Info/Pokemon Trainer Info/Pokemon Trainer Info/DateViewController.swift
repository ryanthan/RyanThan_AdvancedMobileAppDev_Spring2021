//
//  DateViewController.swift
//  Pokemon Trainer Info
//
//  Created by Ryan Than on 2/3/21.
//

import UIKit

class DateViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    let dateFormatter: DateFormatter = DateFormatter()
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .short //Use a short date style
        // Do any additional setup after loading the view.
    }
    
    //Update the label whenever the date is changed
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let selectedDate: String = dateFormatter.string(from: sender.date)
        dateLabel.text = "You became a Pokemon Trainer on \(selectedDate)!"
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
