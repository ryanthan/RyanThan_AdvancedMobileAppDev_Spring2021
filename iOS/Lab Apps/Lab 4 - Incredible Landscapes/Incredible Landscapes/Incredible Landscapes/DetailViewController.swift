//
//  DetailViewController.swift
//  Incredible Landscapes
//
//  Created by Ryan Than on 2/15/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageName : String?
    
    override func viewWillAppear(_ animated: Bool) {
        if let name = imageName { //Set the image and label text based on the chosen image
            imageView.image = UIImage(named: name)
            
            //Switch statement to display the correct name
            switch imageName {
            case "landscape1":
                imageLabel.text = "Antelope Canyon, Arizona"
            case "landscape2":
                imageLabel.text = "Bryce Canyon, Utah"
            case "landscape3":
                imageLabel.text = "Cinque Terre, Italy"
            case "landscape4":
                imageLabel.text = "Lake Lucerne, Switzerland"
            case "landscape5":
                imageLabel.text = "Moraine Lake in Banff National Park, Canada"
            case "landscape6":
                imageLabel.text = "Mù Cang Chải, Vietnam"
            case "landscape7":
                imageLabel.text = "Na'Pali Coast, Kauai, Hawaii"
            case "landscape8":
                imageLabel.text = "Tulip Fields, Netherlands"
            case "landscape9":
                imageLabel.text = "Paro Taktsang, Bhutan"
            case "landscape10":
                imageLabel.text = "Victoria Falls, Zambia and Zimbabwe"
            case "landscape11":
                imageLabel.text = "Reynisfjara Beach, Iceland"
            case "landscape12":
                imageLabel.text = "The Namib Desert, Namibia"
            case "landscape13":
                imageLabel.text = "Salar de Uyuni, Bolivia"
            case "landscape14":
                imageLabel.text = "White Desert, Egypt"
            case "landscape15":
                imageLabel.text = "Lavender Fields in Provence, France"
            case "landscape16":
                imageLabel.text = "Pamukkale, Turkey"
            case "landscape17":
                imageLabel.text = "Table Mountain, South Africa"
            case "landscape18":
                imageLabel.text = "Oia, Greece"
            case "landscape19":
                imageLabel.text = "The Maroon Bells, Colorado"
            case "landscape20":
                imageLabel.text = "Zhangjiajie National Forest, China"
            
            default:
                imageLabel.text = "Error: Image name cannot be found."
            }
            
        }
    }
    
    //Function to allow for the share functionality
    @IBAction func Share(_ sender: UIBarButtonItem) {
        var imageArray = [UIImage]() //Initialize an image array
        imageArray.append(imageView.image!) //Append the current image to the array
        let shareScreen = UIActivityViewController(activityItems: imageArray, applicationActivities: nil) //Create a new view controller
        shareScreen.modalPresentationStyle = .popover //Set the view controller presentation style to popover
        shareScreen.popoverPresentationController?.barButtonItem = sender
        present(shareScreen, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
