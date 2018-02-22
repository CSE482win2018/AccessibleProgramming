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
    
    var manageActivitiesTable = ManageActivitiesTableViewController()
//
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "manageActivitiesTable") as! ManageActivitiesTableViewController
        manageActivitiesTable = vc
//        manageActivitiesTable.parentController = self
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
        manageActivitiesTable.unwindToActivityList(sender: sender)
    }

    private func addViewControllerAsChildViewController(childViewController: UIViewController) {
        addChildViewController(childViewController)
        //        view.addSubview(childViewController.view)
        //        childViewController.view.frame = view.bounds
        //        childViewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        childViewController.didMove(toParentViewController: self)
    }
    
}
