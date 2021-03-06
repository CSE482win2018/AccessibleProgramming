//
//  Activity.swift
//  BlocksForAll
//
//  Created by Kathryn Chan on 06/02/2018.
//  Copyright © 2018 Lauren Milne. All rights reserved.
//

import UIKit
import os.log

class Activity: NSObject, NSCoding {
    
    //MARK: Properties
    var name: String
    var descrip: String?
    
    //    var rating: Int
    
    var solutionBlocksName: [Block]
    var startBlocks: [Block]
    var showInDoActivity: Bool
    var audioURL: URL
    var hints:[(String,URL?)]
    var hintsString: [String]
    var hintsURL: [URL?]
    struct PropertyKey {
        static let name = "name"
        static let descrip = "descrip"
       
        static let solutionBlocksName = "solutionBlocksName"
        static let startBlocks = "startBlocks"
        static let showInDoActivity = "showInDoActivity"
        static let hintsString = "hintsString"
        static let hintsURL = "hintsURL"
        static let audioURL = "audioURL"
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("activities")
    
    //MARK: Initialization
    init?(name: String, descrip: String?, solutionBlocksName: [Block]?, startBlocks: [Block]?, showInDoActivity: Bool,hints:[(String,URL?)]?,audioURL:URL?) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        //        // The rating must be between 0 and 5 inclusively
        //        guard (rating >= 0) && (rating <= 5) else {
        //            return nil
        //        }
        //
        //        // Initialization should fail if there is no name or if the rating is negative.
        //        if name.isEmpty || rating < 0  {
        //            return nil
        //        }
        
        // Initialize stored properties.
        self.name = name
        self.descrip = descrip
        self.solutionBlocksName = solutionBlocksName!
        self.startBlocks = startBlocks!
        self.showInDoActivity = showInDoActivity
        self.hints = hints!
        self.hintsString = []
        self.hintsURL = []
        if (hints != nil && (hints?.count)! > 0) {
            for i in 0...self.hints.count-1 {
                self.hintsString.append(self.hints[i].0)
                self.hintsURL.append(self.hints[i].1)
            }
        }
        
        self.audioURL = audioURL!
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(descrip, forKey: PropertyKey.descrip)
        aCoder.encode(solutionBlocksName, forKey: PropertyKey.solutionBlocksName)
        aCoder.encode(startBlocks, forKey: PropertyKey.startBlocks)
        aCoder.encode(showInDoActivity, forKey: PropertyKey.showInDoActivity)
        aCoder.encode(hintsString, forKey: PropertyKey.hintsString)
        aCoder.encode(hintsURL, forKey: PropertyKey.hintsURL)
        aCoder.encode(audioURL,forKey: PropertyKey.audioURL)

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Activity object.", log: OSLog.default, type: .debug)
            return nil
        }
        // Because photo is an optional property of Meal, just use conditional cast.
        let descrip = aDecoder.decodeObject(forKey: PropertyKey.descrip) as? String
        let solutionBlocksName = aDecoder.decodeObject(forKey: PropertyKey.solutionBlocksName) as? [Block]
        let startBlocks = aDecoder.decodeObject(forKey: PropertyKey.startBlocks) as? [Block]
        //        let hints = aDecoder.decodeObject(forKey: PropertyKey.hints) as? [String]
        let showInDoActivity = aDecoder.decodeBool(forKey: PropertyKey.showInDoActivity) as Bool
        let hintsString = aDecoder.decodeObject(forKey: PropertyKey.hintsString) as? [String]
        let hintsURL = aDecoder.decodeObject(forKey: PropertyKey.hintsURL) as? [URL?]
        let audioURL = aDecoder.decodeObject(forKey: PropertyKey.audioURL) as? URL
        // Must call designated initializer.
        var hints = [(String,URL?)]()
        if (hintsString != nil && (hintsString?.count)! > 0) {
            for i in 0...(hintsString?.count)!-1 {
                hints.append((hintsString![i], hintsURL?[i]))
            }
        }
       
        self.init(name: name, descrip: descrip,  solutionBlocksName: solutionBlocksName, startBlocks: startBlocks, showInDoActivity: showInDoActivity, hints: hints,audioURL: audioURL)
    }
    
    func test(descrip: String = "None"){
        
    }
    
    
}

