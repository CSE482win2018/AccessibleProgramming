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
            activities.removeAll()
            if (savedActivities.count <= 0) {
                loadSampleActivities()
            } else {
                
                for activity in savedActivities {
                    if (activity.showInDoActivity) {
                        activities.append(activity)
                    }
                }
            }
            
        }
        else {
            // Load the sample data.
            //            loadSampleActivities()
        }
        indexHasSet = false
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
    
    var indexHasSet: Bool?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        seletedIndexPath = tableView.indexPathForSelectedRow
        indexHasSet = true
        performSegue(withIdentifier: "doActivity", sender: self)
    }
    
    var eternalBlockViewController : BlocksViewController?
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (segue.identifier ?? "") {
        case "doActivity":
            if (eternalBlockViewController == nil) {
                let dovc = segue.destination as! BlocksViewController
                eternalBlockViewController = dovc
            }
            if (indexHasSet)! {
                
                eternalBlockViewController?.activity = activities[selectedIndex]
                eternalBlockViewController?.viewDidLoad()
            }
            
          
            break
        default:
            break
        }
    }
    
    
    //MARK: Actions
    
   
    
    private func loadActivities() -> [Activity]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Activity.ArchiveURL.path) as? [Activity]
    }
    
    private func loadSampleActivities() {
        let photo1 = UIImage(named: "wiggle")
        let longString = "Your task today is to make a loud crocodile sound! To complete the activity find the crocadile sound in the blocks menu and place it in the block program, then press play to hear the crocadile roar!"
        var solu = [Block]()
        let block = Block(name: "Make Crocodile Noise", color: UIColor.green, double: false, editable: false, imageName: "crocodile_sound.png", type: "Statement")
        solu.append(block!)
        guard let act1=Activity(name: "Sample Activity", descrip: longString, solutionBlocksName: solu, startBlocks: [Block](), showInDoActivity: true,hints:[(String,URL)](),audioURL: URL(string:"https://www.apple.com")) else{
            fatalError("Unable to Load Activity")
        }
        activities.append(act1)
        
    }
    
    
}

