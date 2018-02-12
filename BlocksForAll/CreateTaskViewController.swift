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
    @IBOutlet weak var SolutionBlocksView: UIView!
    
 
    
    @IBOutlet weak var ActivityName: UITextField!
    // area in instruction view
    @IBOutlet weak var Descrip: UITextView!
    
    @IBOutlet weak var InstructionView: UIView!
    
    
//    lazy var instructionViewController : InstructionViewController = {
////        let board = UIStoryboard(name: "Main", bundle: Bundle.main)
//        var vc = self.storyboard.instantiateViewController(withIdentifier: "InstructionViewController") as! InstructionViewController
//        self.addViewControllerAsChildViewController(childViewController: vc)
//
//        return vc
//    }()
    
    lazy var solutionBlocksViewController : SolutionBlocksViewController = {
        let board = UIStoryboard(name: "Main", bundle: Bundle.main)
        var vc = board.instantiateViewController(withIdentifier: "SolutionBlocksViewController") as! SolutionBlocksViewController
        self.addViewControllerAsChildViewController(childViewController: vc)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func switchViewInCreateTask(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            InstructionView.isHidden = false
            SolutionBlocksView.isHidden = true
        case 1, 2:
            InstructionView.isHidden = true
            SolutionBlocksView.isHidden = false
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
    
    
    
    @IBAction func DoneCreate(_ sender: UIBarButtonItem) {
        saveActivity()
        self.performSegue(withIdentifier: "MenuSegue", sender: self)
    }
    @IBAction func SaveButton(_ sender: UIBarButtonItem) {
        let name = ActivityName.text ?? "New_Activity"
        var descrip = ""
        if Descrip != nil && Descrip.text.count > 0 {
            descrip = Descrip.text
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

