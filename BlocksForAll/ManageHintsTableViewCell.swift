//
//  ManageHintsTableViewCell.swift
//  BlocksForAll
//
//  Created by Alex Davis on 2/24/18.
//  Copyright © 2018 Lauren Milne. All rights reserved.
//

import UIKit
import AVFoundation

class ManageHintsTableViewCell: UITableViewCell, AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    //MARK: properties
    @IBOutlet weak var hintText: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    var viewController: ManageHintsTableViewController?
    var audioFileName: String?
    var fileURL: URL!
    @IBAction func deleteHint(_ sender: Any) {
        viewController?.deleteCell(cell: self)
       
        try? FileManager.default.removeItem(at: self.fileURL)
       
    }
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playButton.isEnabled = false
        stopButton.isEnabled = false
        self.audioFileName = randomAlphaNumericString(length: 11)+".caf"
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent(self.audioFileName!)
        self.fileURL=soundFileURL
        //self.viewController?.addURL(cell: self)
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
        //print("fileName: "+(self.audioFileName?)!)
        // Initialization code
    }
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
