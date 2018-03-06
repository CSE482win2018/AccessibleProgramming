//
//  ListViewController.swift
//  BlocksForAll
//
//  Created by Kathryn Chan on 21/02/2018.
//  Copyright © 2018 Lauren Milne. All rights reserved.
//

import UIKit
import os.log

class ListViewController : UIViewController {
    
    @IBOutlet weak var subview: UIView!
    var manageActivitiesTable: ManageActivitiesTableViewController?
    var segue : UIStoryboardSegue?
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "manageActivitiesTable") as! ManageActivitiesTableViewController
        manageActivitiesTable = vc
        //        manageActivitiesTable.parentController = self
        if (segue != nil) {
            manageActivitiesTable?.unwindToActivityList(sender: self.segue!)
        }
        addViewControllerAsChildViewController(childViewController: vc)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "ListToTable") {
//            manageActivitiesTable = segue.destination  as! ManageActivitiesTableViewController
//            // Pass data to secondViewController before the transition
//        }
//        print(manageActivitiesTable.mmm)
    }


    func unwindToActivityList(sender: UIStoryboardSegue) {
        segue = sender
        manageActivitiesTable?.unwindToActivityList(sender: sender)
    }

    private func addViewControllerAsChildViewController(childViewController: UIViewController) {
        addChildViewController(childViewController)
                subview.addSubview(childViewController.view)
//                childViewController.view.frame = view.bounds
//
               childViewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        childViewController.didMove(toParentViewController: self)
    }
    
}
