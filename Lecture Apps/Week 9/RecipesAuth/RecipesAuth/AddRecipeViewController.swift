//
//  AddRecipeViewController.swift
//  RecipesAuth
//
//  Created by Aileen Pierce on 3/8/21.
//

import UIKit

class AddRecipeViewController: UIViewController {

    @IBOutlet weak var recipeTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    var addedrecipe = String()
    var addedurl = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savesegue"{
            if recipeTextField.text?.isEmpty == false {
                addedrecipe = recipeTextField.text!
                addedurl = urlTextField.text!
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
