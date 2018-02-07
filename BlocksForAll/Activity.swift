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
    var hints: [String]?
//    var rating: Int
    
    struct PropertyKey {
        static let name = "name"
        static let descrip = "descrip"
        static let hints = "hints"
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("activities")
    
    //MARK: Initialization
    init?(name: String, descrip: String?, hints: [String]?) {
        
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
        self.hints = hints
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(descrip, forKey: PropertyKey.descrip)
        aCoder.encode(hints, forKey: PropertyKey.hints)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        // Because photo is an optional property of Meal, just use conditional cast.
        let descrip = aDecoder.decodeObject(forKey: PropertyKey.descrip) as? String
        
        let hints = aDecoder.decodeObject(forKey: PropertyKey.hints) as? [String]
        
        // Must call designated initializer.
        self.init(name: name, descrip: descrip, hints: hints)
    }
    
    
}
