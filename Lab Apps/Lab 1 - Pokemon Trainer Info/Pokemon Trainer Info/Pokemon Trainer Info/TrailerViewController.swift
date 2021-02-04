//
//  TrailerViewController.swift
//  Pokemon Trainer Info
//
//  Created by Ryan Than on 2/3/21.
//

import UIKit

class TrailerViewController: UIViewController {

    @IBAction func goToYoutube(_ sender: Any) {
        //Check to see if there is an app installed to handle the URL scheme
        if (UIApplication.shared.canOpenURL(URL(string: "youtube://")!)) { //If Youtube is installed:
            UIApplication.shared.open(URL(string: "youtube://www.youtube.com/watch?v=DyqGhedK8mM")!, options: [:], completionHandler: nil) //Open the video in youtube
        } else { //If Youtube is not installed:
            UIApplication.shared.open(URL(string: "http://www.youtube.com/watch?v=DyqGhedK8mM")!, options: [:], completionHandler: nil) //Open the video in the web browser
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
