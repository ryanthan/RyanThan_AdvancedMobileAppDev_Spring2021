//
//  Loading Screen.swift
//  Ludos
//
//  Created by Ryan Than on 3/29/21.
//

import Foundation
import UIKit

//Class to store common functions used in multiple view controllers
class CommonFunctions {
    //Variables
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    let connectionLabel = UILabel()
    let reachability = try! Reachability()
    var alert = UIAlertController(title: "Internet Connection Error", message: "This app requires a constant Internet connection. Please reconnect or restart the app with a proper connection.", preferredStyle: .alert)
    
    //Modified from: https://stackoverflow.com/questions/29311093/place-activity-indicator-over-uitable-view
    //Function to display a loading screen while the data loads for a table view
    func setTableLoadingScreen(_ viewController: UIViewController, _ tableView: UITableView) {
        //Set up the view that contains the loading text and activity indicator
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (viewController.navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        //Configure the loading text label
        loadingLabel.textColor = .white
        loadingLabel.textAlignment = NSTextAlignment.right
        loadingLabel.text = "Loading..."
        loadingLabel.backgroundColor? = .systemGray5
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 110, height: 40)
        loadingLabel.layer.cornerRadius = 10
        loadingLabel.layer.masksToBounds = true
        loadingLabel.isHidden = false

        //Configure the activity indicator
        spinner.style = .medium
        spinner.color = .white
        spinner.frame = CGRect(x: 2, y: 5, width: 30, height: 30)
        spinner.startAnimating()
        
        //Display label based on Internet connection
        //From: https://github.com/ashleymills/Reachability.swift
        reachability.whenReachable = { _ in
            self.alert.dismiss(animated: true, completion: nil) //Dismiss alert when connected
        }
        
        reachability.whenUnreachable = { _ in
            viewController.present(self.alert, animated: true, completion: nil) //Present alert if not connected
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }

        //Adds the text and activity indicator to the view
        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(spinner)
        loadingView.addSubview(connectionLabel)

        //Present the view
        tableView.addSubview(loadingView)
    }
    
    //Function to display a loading screen while the data loads for a standard view
    func setLoadingScreen(_ viewController: UIViewController) {
        //Set up the view that contains the loading text and activity indicator
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (viewController.view.frame.width / 2) - (width / 2)
        let y = (viewController.view.frame.height / 2) - (height / 2)
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        //Configure the loading text label
        loadingLabel.textColor = .white
        loadingLabel.textAlignment = NSTextAlignment.right
        loadingLabel.text = "Loading..."
        loadingLabel.backgroundColor? = .systemGray5
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 110, height: 40)
        loadingLabel.layer.cornerRadius = 10
        loadingLabel.layer.masksToBounds = true
        loadingLabel.isHidden = false

        //Configure the activity indicator
        spinner.style = .medium
        spinner.color = .white
        spinner.frame = CGRect(x: 2, y: 5, width: 30, height: 30)
        spinner.startAnimating()

        //Display label based on Internet connection
        //From: https://github.com/ashleymills/Reachability.swift
        reachability.whenReachable = { _ in
            self.alert.dismiss(animated: true, completion: nil) //Dismiss alert if connected
        }
        
        reachability.whenUnreachable = { _ in
            viewController.present(self.alert, animated: true, completion: nil) //Present alert if not connected
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }

        //Adds the text and activity indicator to the view
        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(spinner)
        loadingView.addSubview(connectionLabel)

        //Present the view
        viewController.view.addSubview(loadingView)
    }

    //Remove the loading screen
    func removeLoadingScreen() {
        //Hides the text and stops the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        connectionLabel.isHidden = true
    }
    
    //Function to quickly grab images from the URL and add a gradient effect
    //Modified from: https://stackoverflow.com/questions/44519925/swift-3-url-image-makes-uitableview-scroll-slow-issue
    func loadImageGradient(fromURL urlString: String, toImageView imageView: UIImageView) {
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
                }
            }
        }.resume()
    }
}
