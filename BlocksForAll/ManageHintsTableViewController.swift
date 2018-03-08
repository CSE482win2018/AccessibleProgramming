//
//  ManageHintsTableViewController.swift
//  BlocksForAll
//
//  Created by Alex Davis on 2/24/18.
//  Copyright © 2018 Lauren Milne. All rights reserved.
//

import UIKit
import AVFoundation

class ManageHintsTableViewController: UITableViewController,UITextFieldDelegate {
    var hints:[(String,URL?)]=[]
    var parentVC : CreateTaskViewController?
    @IBOutlet weak var addNewHintButton: UIButton!
    @IBAction func addNewhint(_ sender: Any) {
        print("in here")
        
        hints.append(("",URL(string:"https://www.apple.com")))
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        print("TableViewLoaded")
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func deleteCell(cell: ManageHintsTableViewCell){
        if let deletionIndexPath = tableView.indexPath(for: cell){
            hints.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at:[deletionIndexPath], with: .automatic)
        }
        
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hints.count
    }
    
//
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ManageHintsTableViewCell"
        if hints[indexPath.row].0 == ""{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ManageHintsTableViewCell else{
                    fatalError("dequed cell was not a hint")
                }

            let hint = hints[indexPath.row]
            // Configure the cell...
            cell.hintText.text=hint.0
            hints[indexPath.row].1=cell.fileURL
            cell.viewController=self
            cell.hintText.tag = indexPath.row
            cell.hintText.delegate = self
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ManageHintsTableViewCell else{
                fatalError("dequed cell was not a hint")
            }
            
            let hint = hints[indexPath.row]
            // Configure the cell...
            cell.hintText.text=hint.0
            cell.fileURL = hint.1
            cell.viewController=self
            cell.hintText.tag = indexPath.row
            cell.hintText.delegate = self
            cell.isOld = true
            cell.playButton.isEnabled = true
//            // set up record
//            let recordSettings =
//                [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
//                 AVEncoderBitRateKey: 16,
//                 AVNumberOfChannelsKey: 2,
//                 AVSampleRateKey: 44100.0] as [String : Any]
//
//            do {
//                try cell.audioRecorder = AVAudioRecorder(url: cell.fileURL,
//                                                    settings: recordSettings as [String : AnyObject])
//                cell.audioRecorder?.prepareToRecord()
//            } catch let error as NSError {
//                print("audioSession error: \(error.localizedDescription)")
//            }
            // set up playing
//            do {
//                cell.playButton.isEnabled = true
//                try cell.audioPlayer = AVAudioPlayer(contentsOf:
//                    cell.fileURL)
//                cell.audioPlayer!.delegate = cell
//                cell.audioPlayer!.prepareToPlay()
//            } catch let error as NSError {
//                print("audioPlayer error: \(error.localizedDescription)")
//            }
            return cell
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ManageHintsTableViewCell
//            cell?.textLabel?.text = hints[indexPath.row].0
//            cell?.fileURL = hints[indexPath.row].1
//            return cell!
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {      //delegate method
        print("in did begin editing")
        //you will get the row. items[textField.tag] will get the object
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {   //delegate method
        print(textField.tag)
        print("in Should End Editing")//you will get the row. items[textField.tag] will get the object
        hints[textField.tag].0 = textField.text!
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {     //delegate method
        print("in should return")
        textField.resignFirstResponder()
        return true
    }
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }

    func signalFromCreate() {
        parentVC?.getHints(hints: self.hints)
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

}
