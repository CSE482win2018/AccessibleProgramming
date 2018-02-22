//
//  Block.swift
//  BlocksForAll
//
//  Created by Lauren Milne on 2/28/17.
//  Copyright © 2017 Lauren Milne. All rights reserved.
//

import UIKit
import os.log

class Block: NSObject, NSCoding  {

    
    struct PropertyKey {
        static let name = "name"
        
        static let color = "color"
        static let double = "double" //true if needs both beginning and end block like repeat
        static let editable = "editable" //true if has options
        static let options = "options"
        static let optionsLabels  = "optionsLabels"
        static let pickedOption = "pickedOption"
        static let imageName = "imageName"
        static let addedBlocks="addedBlocks"
        static let type = "type"
        static let acceptedTypes = "acceptedTypes"
        
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(color, forKey: PropertyKey.color)
        aCoder.encode(double, forKey: PropertyKey.double)
         aCoder.encode(editable, forKey: PropertyKey.editable)
         aCoder.encode(options, forKey: PropertyKey.options)
         aCoder.encode(optionsLabels, forKey: PropertyKey.optionsLabels)
         aCoder.encode(pickedOption, forKey: PropertyKey.pickedOption)
         aCoder.encode(imageName, forKey: PropertyKey.imageName)
         aCoder.encode(addedBlocks, forKey: PropertyKey.addedBlocks)
        aCoder.encode(type, forKey: PropertyKey.type)
        aCoder.encode(acceptedTypes, forKey: PropertyKey.acceptedTypes)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
         // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Block object.", log: OSLog.default, type: .debug)
            return nil
        }
        // Because photo is an optional property of Meal, just use conditional cast.
        let color = aDecoder.decodeObject(forKey: PropertyKey.color) as? UIColor
        let double = aDecoder.decodeBool(forKey: PropertyKey.double) as Bool

        let editable = aDecoder.decodeBool(forKey: PropertyKey.editable) as Bool
        let options = aDecoder.decodeObject(forKey: PropertyKey.options) as?  [String]
        let optionsLabels = aDecoder.decodeObject(forKey: PropertyKey.optionsLabels) as? [String]
        let pickedOption = aDecoder.decodeInteger(forKey: PropertyKey.pickedOption) as Int
        let imageName = aDecoder.decodeObject(forKey: PropertyKey.imageName) as? String?
        let addedBlocks = aDecoder.decodeObject(forKey: PropertyKey.addedBlocks) as? [Block]
        let type = aDecoder.decodeObject(forKey: PropertyKey.type) as? String
        let acceptedTypes = aDecoder.decodeObject(forKey: PropertyKey.acceptedTypes) as? [String]
        //        let hints = aDecoder.decodeObject(forKey: PropertyKey.hints) as? [String]
        
        // Must call designated initializer.
        self.init(name: name, color: color!, double: double, editable: editable, imageName: imageName!, options: options!, pickedOption: pickedOption, optionsLabels: optionsLabels!, addedBlocks: addedBlocks!, type: type!, acceptedTypes: acceptedTypes!)
    }
    
    
    
    
    //MARK: Properties
    
    var name: String
    var color: UIColor
    var double: Bool //true if needs both beginning and end block like repeat
    var counterpart: Block?
    var editable: Bool //true if has options
    var options: [String] = []
    var optionsLabels: [String] = []
    var pickedOption: Int = 0
    var imageName: String?
    var addedBlocks: [Block] = []
    var type: String = "Operation"
    var acceptedTypes: [String] = []
    
    //MARK: Initialization
    
    init?(name: String, color: UIColor, double: Bool, editable: Bool, imageName: String? = nil, options: [String] = [], pickedOption: Int = 0, optionsLabels: [String] = [], addedBlocks: [Block] = [], type: String = "Operation", acceptedTypes: [String] = []){
        
        //TODO: check that color is initialized as well
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.color = color
        self.double = double
        self.editable = editable
        self.imageName = imageName
        self.options = options
        self.pickedOption = pickedOption
        self.optionsLabels = optionsLabels
        self.addedBlocks = addedBlocks
        self.type = type
        self.acceptedTypes = acceptedTypes
    }
    
    func addImage(_ imageName: String){
        self.imageName = imageName
    }
    
   
    
    
    func copy(fake: Int) -> Block{
        let newBlock = Block.init(name: self.name, color: self.color, double: self.double, editable: self.editable, imageName: self.imageName, options: self.options, pickedOption: self.pickedOption, optionsLabels: self.optionsLabels, addedBlocks: self.addedBlocks, type: self.type, acceptedTypes: self.acceptedTypes)
        return newBlock!
    }

}
