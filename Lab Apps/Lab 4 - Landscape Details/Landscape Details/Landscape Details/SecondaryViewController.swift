//
//  SecondaryViewController.swift
//  Landscape Details
//
//  Created by Ryan Than on 2/17/21.
//

import UIKit
import WebKit

class SecondaryViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    var webpage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        loadWebPage("https://en.wikipedia.org/wiki/Earth")
    }
    
    //Function to load the webpage
    func loadWebPage(_ urlString: String){
        //Creates a URL object
        let myurl = URL(string: urlString)
        //Create a URLRequest object
        let request = URLRequest(url: myurl!)
        //Load the URLRequest object in the web view
        webView.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let url = webpage { //Load the webpage if it is not null
            loadWebPage(url)
        }
    }
    
    //Function is called when the website begins to load
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingSpinner.startAnimating() //Start the activity indicator animation
    }
    
    //Function is called when the website has finished loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingSpinner.stopAnimating() //Stop the activity indicator animation
    }
}
