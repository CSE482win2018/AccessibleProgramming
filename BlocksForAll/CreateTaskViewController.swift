//
//  CreateTaskViewController.swift
//  BlocksForAll
//
//  Created by Kathryn Chan on 01/02/2018.
//  Copyright © 2018 Lauren Milne. All rights reserved.
//

import UIKit
class CreateTaskViewController: UIViewController  {
    
    @IBOutlet weak var InstructionView: UIView!
    @IBOutlet weak var SolutionBlocksView: UIView!
    
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
    
    
    
}
