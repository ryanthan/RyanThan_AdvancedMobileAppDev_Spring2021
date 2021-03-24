//
//  AddDessertViewController.swift
//  Favorite Desserts
//
//  Created by Ryan Than on 2/14/21.
//

import UIKit

class AddDessertViewController: UIViewController {

    @IBOutlet weak var addDessertLabel: UILabel!
    @IBOutlet weak var addDessertTextField: UITextField!
    
    var addedDessert = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addDessertLabel.text = "Please add your favorite type of \(self.title!.lowercased())!" //Fill in the label
    }
    
    //Prepare to send data through the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveSegue" {
            if addDessertTextField.text?.isEmpty == false { //If there is text in the text field, add the dessert
                addedDessert = addDessertTextField.text!
            }
        }
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
