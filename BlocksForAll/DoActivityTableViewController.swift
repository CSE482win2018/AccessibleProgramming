//
//  DoActivityTableViewController.swift
//  BlocksForAll
//
//  Created by Kathryn Chan on 25/02/2018.
//  Copyright © 2018 Lauren Milne. All rights reserved.
//


import UIKit
import os.log

class DoActivityTableViewController: UITableViewController {
    //MARK: Properties
    
    var activities=[Activity]()
    var selectedIndex = 0;
    var seletedIndexPath: IndexPath?;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Load any saved meals, otherwise load sample data.
        if let savedActivities = loadActivities() {
            for activity in savedActivities {
                if (activity.showInDoActivity) {
                    activities.append(activity)
                }
            }
        }
        else {
            // Load the sample data.
            //            loadSampleActivities()
        }
    }
    //    func setParent(segue: UIStoryboardSegue) {
    //        if (segue.identifier == "ListToTable") {
    //            parentController = segue.source as? ListViewController
    //        }
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activities.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DoActivityTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)as? DoActivityTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DoActivityTableViewCell.")
        }
        // Fetches the appropriate meal for the data source layout.
        let act = activities[indexPath.row]
        // Configure the cell...
        cell.nameLabel.text=act.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        seletedIndexPath = tableView.indexPathForSelectedRow
        performSegue(withIdentifier: "doActivity", sender: self)
    }
    
    
   
    
    
 
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (segue.identifier ?? "") {
        case "doActivity":
            let dovc = segue.destination as! BlocksViewController
            dovc.activity = activities[selectedIndex]
            
          
            break
        default:
            break
        }
    }
    
    
    //MARK: Actions
    
   
    
    private func loadActivities() -> [Activity]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Activity.ArchiveURL.path) as? [Activity]
    }
    
    
}

