//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance //this is singleton (single instance of this object) to ensure that everything is using and happening in same space, using same managed object... dont, want to keep creating versions of the dataStore. We want to use the same one and access it's properties throughout program. Thus using sharedInstance othewrise would get many conflicting errors.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        
        
        store.getRepositoriesWithCompletion {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.tableView.reloadData()
            })
        }
        
    }
    
    // MARK: - Table view data source
    //when a cell in the table view is selected, it should call your ReposDataStore method to toggle the starred status and display a UIAlertController saying either "You just starred REPO NAME" or "You just unstarred REPO NAME". You should also set the accessibilityLabel of the presented alert controller to either "You just starred REPO NAME" or "You just unstarred REPO NAME" (depending on the action that just occurred).
    
    func starredAlertController(){
        
        let alertController = UIAlertController(title: "Alert", message: "You just starred this repository", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel){(action) -> Void in })
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {(action) -> Void in })
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func unstarredAlertController() {
        
        
        let alertController = UIAlertController(title: "Alert", message: "You just unstarred this repository", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
        
        let repository:GithubRepository = self.store.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedRepo = self.store.repositories[indexPath.row]
        
        store.toggleStarStatusForRepository(selectedRepo) { (toggle) in
            
            
            if toggle == true { //if toggleStarStatus completion block was written without taking a bool, would just check if toggle  vs !toggle instead of comparing to true or false
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    
                    self.starredAlertController()
                })
                
            } else if toggle == false {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.unstarredAlertController()
                })
            }
            
        }
        
    }
    
}


//
//class ReposTableViewController: UITableViewController {
//
//    let store = ReposDataStore.sharedInstance
//    var starController = UIAlertController()
//    var unstarController = UIAlertController()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//    }
//
//                // When a cell in the table view is selected, toggle the starred status and display a UIAlertController saying either "You just starred REPO NAME" or "You just unstarred REPO NAME".
//                   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//                            let selectedRepo = self.store.repositories[indexPath.row]
//                            configureAlertControllers(selectedRepo.fullName)
//
//                           store.toggleStarStatusForRepository(selectedRepo) { (toggleStar) in
//                               if toggleStar {
//                                    self.presentViewController(self.starController, animated: true, completion: nil)
//                               } else if !toggleStar {
//                                    self.presentViewController(self.unstarController, animated: true, completion: nil)
//                                }
//                            }
//                        }
//
//
//            func configureAlertControllers(repoName: String) {
//                  starController = UIAlertController(title: "⭐️STAR⭐️", message: "You just starred \(repoName).", preferredStyle: .Alert)
//                        starController.accessibilityLabel = "You just starred REPO NAME"
//                     addDismissActionToAlert(starController)
//
//                       unstarController = UIAlertController(title: "💔UNSTAR💔", message: "You just unstarred \(repoName).", preferredStyle: .Alert)
//                        unstarController.accessibilityLabel = "You just unstarred REPO NAME"
//                       addDismissActionToAlert(unstarController)
//               }
//
//            func addDismissActionToAlert(alert: UIAlertController) {
//                   let okStarAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                       alert.dismissViewControllerAnimated(true, completion: nil)
//                    }
//                    alert.addAction(okStarAction)
//                }
//
//    }
