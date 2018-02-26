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
    @IBOutlet weak var startBlocksView: UIView!
    
    @IBOutlet weak var activity_name: UITextField!
    
    @IBOutlet weak var activity_descrip: UITextView!
    // area in instruction view
    @IBOutlet weak var instructionView: UIView!
    
    var solutionBlocksName = [Block]()
    var startBlocks = [Block]()
    var blocksViewController = BlocksViewController()
    var startBlocksViewController = BlocksViewController()
    
    var delegate:BlockSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "blocksViewController") as! BlocksViewController
        blocksViewController = vc
        self.blocksViewController.parentController = self
        addViewControllerAsChildViewController(childViewController: vc)
        
        let startBlocksViewControllerVC = self.storyboard?.instantiateViewController(withIdentifier: "startBlocksViewController") as! BlocksViewController
        startBlocksViewController = startBlocksViewControllerVC
        self.startBlocksViewController.parentController = self
        addViewControllerAsChildViewController(childViewController: startBlocksViewControllerVC)
        if (activity != nil) {
            reloadActivity()
        }
        
        if (forceReload) {
            reloadActivity()
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch (segue.identifier ?? "") {
        case "SaveSegue":
            let listViewController = segue.destination as! ListViewController
            listViewController.unwindToActivityList(sender: segue)
            break
        
        default:
            break
        }
    }
    
    func reloadActivity() {
        justLoad = 0
        activity_name.text = activity?.name
        activity_descrip.text = activity?.descrip
        solutionBlocksName.removeAll()
        solutionBlocksName = (activity?.solutionBlocksName)!
        blocksViewController.reloadBlocks(savedblocks: solutionBlocksName)
        getBlocksFlag = 0
        startBlocks.removeAll()
        startBlocks = (activity?.startBlocks)!
        getBlocksFlag = 1
        startBlocksViewController.reloadBlocks(savedblocks: startBlocks)
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
 
    var forceReload = false
    @IBAction func segmentedViewToggle(_ sender: UISegmentedControl) {
        updateBlocks()
        switch sender.selectedSegmentIndex {
        case 0:
            instructionView.isHidden = false
            blocksView.isHidden = true
            startBlocksView.isHidden = true
        case 1:
            instructionView.isHidden = true
            blocksView.isHidden = false
            startBlocksView.isHidden = true
            getBlocksFlag = 0
            blocksViewController.reloadBlocks(savedblocks: solutionBlocksName)
        case 2:
            instructionView.isHidden = true
            blocksView.isHidden = true
            startBlocksView.isHidden = false
            getBlocksFlag = 1
            startBlocksViewController.reloadBlocks(savedblocks: startBlocks)
        default:
            break
        }
        updateBlocks()
    }
    
    func reloadViewFromNib() {
        let parent = blocksView.superview
        blocksView.removeFromSuperview()
//        blocksView = nil
        parent?.addSubview(blocksView) // This line causes the view to be reloaded
    }
    
  
    
    @IBAction func DoneButton(_ sender: UIButton) {
        updateBlocks()
        saveActivity()
//        self.performSegue(withIdentifier: "SaveSegue", sender: self)
    }

var justLoad = 0
var getBlocksFlag = 0
    
    private func saveActivity() {
        let name = activity_name.text ?? "New_Activity"
        var descrip = ""
        let photo = activity?.photo
        if activity_descrip != nil && activity_descrip.text.count > 0 {
            descrip = activity_descrip.text
        }
        let solutionBlocks = self.solutionBlocksName
        let startBlocks = self.startBlocks

        activity = Activity(name: name, descrip: descrip, photo:photo, solutionBlocksName: solutionBlocks, startBlocks: startBlocks)
        
    }
    
    func updateBlocks() {
        if (justLoad>0) {
            
            if (getBlocksFlag == 0) {
                blocksViewController.sendDataToVc()
            } else {
                startBlocksViewController.sendDataToVc()
            }
        } else {
            justLoad = 1
        }
        
        
    }

    func getBlocks(blocks : [Block]){
        if (getBlocksFlag == 0) {
            solutionBlocksName.removeAll()
            for block in blocks{
                solutionBlocksName.append(block)
            }
            //        for block in blocks{
            //            solutionBlocksName.append(block.name)
            //        }
            if (solutionBlocksName.count > 0) {
                os_log("Solution Blocks successfully got.", log: OSLog.default, type: .debug)
            }
        } else {
            startBlocks.removeAll()
            for block in blocks{
                startBlocks.append(block)
            }

            if (startBlocks.count > 0) {
                os_log("Solution Blocks successfully got.", log: OSLog.default, type: .debug)
            }
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


