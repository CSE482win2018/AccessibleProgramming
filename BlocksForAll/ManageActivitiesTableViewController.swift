//
//  ManageActivitiesTableViewController.swift
//  BlocksForAll
//
//  Created by Alex Davis on 2/19/18.
//  Copyright © 2018 Lauren Milne. All rights reserved.
//

import UIKit
import os.log

class ManageActivitiesTableViewController: UITableViewController {
    //MARK: Properties
    
    var activities=[Activity]()
    var parentController : ListViewController?
    var selectedIndex = -1;
    var seletedIndexPath: IndexPath?;
    var mmm = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load any saved meals, otherwise load sample data.
        if let savedActivities = loadActivities() {
            activities.removeAll()
            if (savedActivities.count <= 0) {
                loadSampleActivities()
            } else {
                
                activities += savedActivities
            }
        } else {
            loadSampleActivities()
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
        let cellIdentifier = "ManageActivitiesTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)as? ManageActivitiesTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ManageActivityTableViewCell.")
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
        
        performSegue(withIdentifier: "editActivity", sender: self)
        
    }

    
     // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         //Return false if you do not want the specified item to be editable.
        return true
    }
 

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            activities.remove(at: indexPath.row)
            saveActivities()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    var oldActivity : Activity?
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (segue.identifier ?? "") {
        case "editActivity":
            let ctvc = segue.destination as! CreateTaskViewController
            ctvc.activity = activities[selectedIndex]
            oldActivity = activities[selectedIndex]
            print(selectedIndex)
            ctvc.memorizeIndex(selectedIndex: selectedIndex,seletedIndexPath: seletedIndexPath)
            // cheat: delete the original one, and add a new one later
//            activities.remove(at: selectedIndex)
//            saveActivities()
//            tableView.deleteRows(at: [seletedIndexPath!], with: .fade)

//            guard let selectedActivityCell = sender as? ManageActivitiesTableViewCell else {
//                fatalError("Unexpected sender: \(sender)")
//            }
//
//            guard let indexPath = tableView.indexPath(for: selectedActivityCell) else {
//                fatalError("The selected cell is not being displayed by the table")
//            }
//
//            let selectedMeal = activities[indexPath.row]
//            mealDetailViewController.meal = selectedMeal
            break
        default:
            break
        }
    }
    
    func updateTableCell() {
        activities.remove(at: selectedIndex)
        
        tableView.deleteRows(at: [seletedIndexPath!], with: .fade)
    }
    
   
    
    //MARK: Actions
    
     func unwindToActivityList(sender: UIStoryboardSegue) {
        if let savedActivities = loadActivities() {
            activities.removeAll()
            activities += savedActivities
        }
        if let createTaskViewController = sender.source as? CreateTaskViewController, let activity = createTaskViewController.activity {
            if let selectedIndexPath = createTaskViewController.tableIndexPath {
                // Update an existing activity.

                activities[createTaskViewController.tableIndex] = activity
                saveActivities()
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: activities.count, section: 0)
                
                activities.append(activity)
                saveActivities()
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
        }
    }
    //MARK: Private Methods
    
    private func loadSampleActivities() {
        let photo1 = UIImage(named: "wiggle")
        let longString = "Your task today is to make a loud crocodile sound! To complete the activity find the crocadile sound in the blocks menu and place it in the block program, then press play to hear the crocadile roar!"
        var solu = [Block]()
        let block = Block(name: "Make Crocodile Noise", color: UIColor.green, double: false, editable: false, imageName: "crocodile_sound.png", type: "Statement")
        solu.append(block!)
        guard let act1=Activity(name: "Sample Activity", descrip: longString, solutionBlocksName: solu, startBlocks: [Block](), showInDoActivity: true,hints:[(String,URL?)](),audioURL: URL(string:"https://www.apple.com")) else{
            fatalError("Unable to Load Activity")
        }
        activities.append(act1)
        saveActivities()
    }
    
    private func saveActivities() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(activities, toFile: Activity.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Activities successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Activities...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadActivities() -> [Activity]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Activity.ArchiveURL.path) as? [Activity]
    }

    
}
