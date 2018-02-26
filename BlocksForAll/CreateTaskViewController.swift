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
    @IBOutlet weak var startBlocksView: UIView!
    
    @IBOutlet weak var hintsView: UIView!
    @IBOutlet weak var activity_name: UITextField!
    
    @IBOutlet weak var activity_descrip: UITextView!
    // area in instruction view
    @IBOutlet weak var instructionView: UIView!
    

    var solutionBlocksName = [Block]()
    var startBlocks = [Block]()

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
    
    var audioFileName :String!
    var blocksViewController = BlocksViewController()
    var startBlocksViewController = BlocksViewController()
    
    
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


