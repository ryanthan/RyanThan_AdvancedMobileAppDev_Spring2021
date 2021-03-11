//
//  RecipeTableViewController.swift
//  RecipesAuth
//
//  Created by Aileen Pierce on 3/8/21.
//

import UIKit
import FirebaseUI

class RecipeTableViewController: UITableViewController, FUIAuthDelegate {
    var recipes = [Recipe]()
    var recipeDataHandler = RecipeDataHandler()
    
    //Firebase AuthUI object
    var authUI: FUIAuth!

    override func viewDidLoad() {
        super.viewDidLoad()

        //assign the closure with the method we want called to the onDataUpdate closure
        recipeDataHandler.onDataUpdate = {[weak self] (data:[Recipe]) in self?.render()}
        recipeDataHandler.dbSetup()
        
        //authentication
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    func render(){
        recipes=recipeDataHandler.getRecipes()
        //reload the table data
        tableView.reloadData()
    }

    @IBAction func unwindSegue(segue:UIStoryboardSegue){
        if segue.identifier == "savesegue" {
            let source = segue.source as! AddRecipeViewController
            if source.addedrecipe.isEmpty == false {
                recipeDataHandler.addRecipe(name: source.addedrecipe, url: source.addedurl)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showdetail" {
            let detailVC = segue.destination as! WebViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let recipe = recipes[indexPath.row]
            //sets the data for the destination controller
            detailVC.title = recipe.name
            detailVC.webpage = recipe.url
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "addrecipe" {
            if isUserSignedIn(){
                return true
            } else {
                return false
            }
        }
        else {
            return true
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipecell", for: indexPath)
        let recipe = recipes[indexPath.row]
        cell.textLabel!.text = recipe.name
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isUserSignedIn(){
                // Delete the row from the data source
                if let recipeID = recipes[indexPath.row].id {
                    recipeDataHandler.deleteRecipe(recipeID: recipeID)
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Authentication
    
    // delegate method that handles the result of the Google sign-up flows
//    func application(_ app: UIApplication, open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        print("in app open options")
//        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
//        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
//            return true
//        }
//        // other URL handling goes here
//        return false
//    }

    //delegate method called when signed it
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        guard let authUser = user else { return }
        //create a UIAlertController object
            let alert=UIAlertController(title: "Firebase", message: "Welcome to Firebase \(authUser.displayName!)", preferredStyle: UIAlertController.Style.alert)
            //create a UIAlertAction object for the button
            let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        
        guard let authError = error else { return }
     
        let errorCode = UInt((authError as NSError).code)
     
        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break
     
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)");
        }
    }
    
    func isUserSignedIn() -> Bool {
        if authUI?.auth?.currentUser == nil {
            //create a UIAlertController object
            let alert=UIAlertController(title: "Firebase", message: "Please login to save your recipes", preferredStyle: UIAlertController.Style.alert)
            //create a UIAlertAction object for the button
            let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    @IBAction func login(_ sender: Any) {
        //authentication providers
        let providers: [FUIAuthProvider] = [FUIGoogleAuth(authUI: authUI!)]
        authUI?.providers = providers
        if authUI?.auth?.currentUser == nil {
            // get the sign-in method selector
            let authViewController = authUI?.authViewController()
            // present the auth view controller
            present(authViewController!, animated: true, completion: nil)
        } else {
            //already signed in
            let name = authUI?.auth?.currentUser!.displayName
            let alert=UIAlertController(title: "Firebase", message: "You're already logged into Firebase  \(name!)", preferredStyle: UIAlertController.Style.alert)
            //create a UIAlertAction object for the button
            let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            //print("\(authUI?.auth?.currentUser) is the currently logged in")
        }
    }
    
    
    @IBAction func logout(_ sender: Any) {
        do{
            try authUI?.signOut()
            let alert=UIAlertController(title: "Firebase", message: "You've been logged out of Firebase", preferredStyle: UIAlertController.Style.alert)
            //create a UIAlertAction object for the button
            let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } catch {
            print("You were not logged out")
        }
    }
}
