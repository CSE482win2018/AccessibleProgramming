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
    
    var solutionBlocks = [Block]()
    
    var blocksViewController = BlocksViewController()
    var solutionView: BlocksViewController = BlocksViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "blocksViewController") as! BlocksViewController
        blocksViewController = vc
        self.blocksViewController.parentController = self
        addViewControllerAsChildViewController(childViewController: vc)
        print(vc.answer)
    }
    //    lazy var instructionViewController : InstructionViewController = {
    ////        let board = UIStoryboard(name: "Main", bundle: Bundle.main)
    //        var vc = self.storyboard.instantiateViewController(withIdentifier: "InstructionViewController") as! InstructionViewController
    //        self.addViewControllerAsChildViewController(childViewController: vc)
    //
    //        return vc
    //    }()
    
//    lazy var solutionBlocksViewController : BlocksViewController = {
//        let board = UIStoryboard(name: "Main", bundle: Bundle.main)
//        var vc = board.instantiateViewController(withIdentifier: "SolutionBlocksViewController") as! BlocksViewController
//        self.addViewControllerAsChildViewController(childViewController: vc)
//        return vc
//    }()
//
 
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
//        let blocksView = childViewControllers.last as! BlocksViewController
        blocksViewController.sendDataToVc()
        let name = activity_name.text ?? "New_Activity"
        var descrip = ""
        let photo = activity?.photo
        if activity_descrip != nil && activity_descrip.text.count > 0 {
            descrip = activity_descrip.text
        }
        print(descrip)
        activity = Activity(name: name, descrip: descrip, photo:photo, solutionBlocks: self.solutionBlocks)
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
    
    func getBlocks(blocks : [Block]){
        solutionBlocks = blocks
        if (solutionBlocks.count > 0) {
            os_log("Solution Blocks successfully got.", log: OSLog.default, type: .debug)
        }
    }

    
    private func addViewControllerAsChildViewController(childViewController: UIViewController) {
        addChildViewController(childViewController)
//        view.addSubview(childViewController.view)
//        childViewController.view.frame = view.bounds
//        childViewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        childViewController.didMove(toParentViewController: self)
    }
    
    
    
}


