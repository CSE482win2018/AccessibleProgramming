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
    
    @IBOutlet weak var blocksView: UIView!
    
    @IBOutlet weak var activity_name: UITextField!
    
    @IBOutlet weak var activity_descrip: UITextView!
    // area in instruction view
    @IBOutlet weak var instructionView: UIView!
    
    
    
    //    lazy var instructionViewController : InstructionViewController = {
    ////        let board = UIStoryboard(name: "Main", bundle: Bundle.main)
    //        var vc = self.storyboard.instantiateViewController(withIdentifier: "InstructionViewController") as! InstructionViewController
    //        self.addViewControllerAsChildViewController(childViewController: vc)
    //
    //        return vc
    //    }()
    
//    lazy var solutionBlocksViewController : SolutionBlocksViewController = {
//        let board = UIStoryboard(name: "Main", bundle: Bundle.main)
//        var vc = board.instantiateViewController(withIdentifier: "SolutionBlocksViewController") as! SolutionBlocksViewController
//        self.addViewControllerAsChildViewController(childViewController: vc)
//        return vc
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func segmentedViewToggle(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            instructionView.isHidden = false
            blocksView.isHidden = true
        case 1, 2:
            instructionView.isHidden = true
            blocksView.isHidden = false
        default:
            break
        }
    }

    
    //    // Mark: view Methods
    //    private func setupView() {
    //        setupSegmentedControl()
    //    }
    //    private func updateView() {
    //        setupSegmentedControl()
    //    }
    
    
    @IBAction func DoneButton(_ sender: UIButton) {
        saveActivity()
        self.performSegue(withIdentifier: "MenuSegue", sender: self)
    }
    
    @IBAction func SaveButton(_ sender: UIButton) {
        let name = activity_name.text ?? "New_Activity"
        var descrip = ""
        if activity_descrip != nil && activity_descrip.text.count > 0 {
            descrip = activity_descrip.text
        }
        print(descrip)
        activity = Activity(name: name, descrip: descrip)
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
    
    private func addViewControllerAsChildViewController(childViewController: UIViewController) {
        addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        childViewController.didMove(toParentViewController: self)
    }
    
    
    
}


