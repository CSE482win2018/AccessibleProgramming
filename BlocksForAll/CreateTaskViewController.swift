//
//  CreateTaskViewController.swift
//  BlocksForAll
//
//  Created by Kathryn Chan on 01/02/2018.
//  Copyright © 2018 Lauren Milne. All rights reserved.
//

import UIKit
import os.log

class CreateTaskViewController: UIViewController  {
    var activity: Activity?
    @IBOutlet weak var InstructionView: UIView!
    @IBOutlet weak var SolutionBlocksView: UIView!
    
    @IBOutlet weak var ActivityName: UITextField!
    
    
    // area in instruction view
    @IBOutlet weak var Description: UITextView!
    @IBOutlet weak var Hints: UITableView!
    
    @IBAction func switchViewInCreateTask(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            InstructionView.isHidden = false
            SolutionBlocksView.isHidden = true
        case 1:
            InstructionView.isHidden = true
            SolutionBlocksView.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func SaveButton(_ sender: UIBarButtonItem) {
        let name = ActivityName.text ?? ""
        let descrip = Description.text
        var hints: [String] = []
        activity = Activity(name: name, descrip: descrip, hints: hints)
        saveActivity()
    }
    
    
    // save in user device
    private func saveActivity() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(activity, toFile: Activity.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Activity successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save activity...", log: OSLog.default, type: .error)
        }

    }
    
    
    
}
