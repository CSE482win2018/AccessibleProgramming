//
//  ManageActivitiesTableViewController.swift
//  BlocksForAll
//
//  Created by Alex Davis on 2/19/18.
//  Copyright © 2018 Lauren Milne. All rights reserved.
//

import UIKit

class ManageActivitiesTableViewController: UITableViewController {
    //MARK: Properties
    
    var activities=[Activity]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleActivities()
       
    }

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
        cell.photoImageView.image=act.photo
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: Private Methods
    
    private func loadSampleActivities() {
        let photo1 = UIImage(named: "wiggle")
        let longString = "Your task today is to make a loud crocodile sound! To complete the activity find the crocodile sound in the blocks menu and place it in the block program, then press play to hear the crocodile roar!"
        guard let act1=Activity(name: "Croc", descrip: longString, photo: photo1!, solutionBlocks: []) else{
            fatalError("Unable to Load Activity")
        }
        activities+=[act1]
    }
    
}
