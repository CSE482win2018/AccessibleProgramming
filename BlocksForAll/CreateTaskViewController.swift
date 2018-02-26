//
//  CreateTaskViewController.swift
//  BlocksForAll
//
//  Created by Kathryn Chan on 01/02/2018.
//  Copyright © 2018 Lauren Milne. All rights reserved.
//
import AVFoundation
import UIKit
import os.log

class CreateTaskViewController: UIViewController , AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    var activity: Activity?
    
    @IBOutlet weak var blocksView: UIView!
    
    @IBOutlet weak var hintsView: UIView!
    @IBOutlet weak var activity_name: UITextField!
    
    @IBOutlet weak var activity_descrip: UITextView!
    // area in instruction view
    @IBOutlet weak var instructionView: UIView!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func recordAudio(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            playButton.isEnabled = false
            stopButton.isEnabled = true
            audioRecorder?.record()
        }
    }
    
    @IBAction func stopAudio(_ sender: Any) {
        stopButton.isEnabled = false
        playButton.isEnabled = true
        recordButton.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
    }
    @IBAction func playAudio(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            stopButton.isEnabled = true
            recordButton.isEnabled = false
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf:
                    (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
    }
    
   
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    var solutionBlocksName = [Block]()
    var audioFileName :String!
    var blocksViewController = BlocksViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "blocksViewController") as! BlocksViewController
        blocksViewController = vc
        self.blocksViewController.parentController = self
        addViewControllerAsChildViewController(childViewController: vc)
        if (activity != nil) {
            reloadActivity()
        }
        
        playButton.isEnabled = false
        stopButton.isEnabled = false
        
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        audioFileName = randomAlphaNumericString(length: 11)+".caf"
        let soundFileURL = dirPaths[0].appendingPathComponent(audioFileName)
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        print("fileName: "+audioFileName)
 
    }
  

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
        
        activity_name.text = activity?.name
        activity_descrip.text = activity?.descrip
        blocksViewController.reloadBlocks(savedblocks: (activity?.solutionBlocksName)!)
        
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

    
  
    
    @IBAction func DoneButton(_ sender: UIButton) {
        saveActivity()
//        self.performSegue(withIdentifier: "SaveSegue", sender: self)
    }
    
    @IBAction func SaveButton(_ sender: UIButton) {
//        let blocksView = childViewControllers.last as! BlocksViewController
        saveActivity()
        self.performSegue(withIdentifier: "SaveSegue", sender: self)
    }
    
    private func saveActivity() {
        blocksViewController.sendDataToVc()
        let name = activity_name.text ?? "New_Activity"
        var descrip = ""
        let photo = activity?.photo
        if activity_descrip != nil && activity_descrip.text.count > 0 {
            descrip = activity_descrip.text
        }
        print(descrip)
        //print(solutionBlocksName[0].name)
        activity = Activity(name: name, descrip: descrip, photo:photo, solutionBlocksName: solutionBlocksName)
        
    }
    
//    // save in user device
//    private func saveActivity() {
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(activity, toFile: Activity.ArchiveURL.path)
//        if isSuccessfulSave {
//            os_log("Activity successfully saved.", log: OSLog.default, type: .debug)
//        } else {
//            os_log("Failed to save activity...", log: OSLog.default, type: .error)
//        }
//
//    }
    
    func getBlocks(blocks : [Block]){
        for block in blocks{
            solutionBlocksName.append(block)
        }
//        for block in blocks{
//            solutionBlocksName.append(block.name)
//        }
        if (solutionBlocksName.count > 0) {
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
    //audio recorder stuff
    
   
    
   
  
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        stopButton.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
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
 
}


