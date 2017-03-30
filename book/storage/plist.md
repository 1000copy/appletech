//
//  ViewController.swift
//  ReadWritePlistTutorial
//
//  Created by rebeloper on 1/31/15.
//  Copyright (c) 2015 Rebeloper. All rights reserved.
//

import UIKit
extension String {
    func stringByAppendingPathComponent(_ path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    func stringByAppendingString(_ path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
}

// MARK: == GameData.plist Keys ==
let BedroomFloorKey = "BedroomFloor"
let BedroomWallKey = "BedroomWall"
// MARK: -

class ViewController: UIViewController {
  
  // MARK: == Variables ==
  var bedroomFloorID: AnyObject = 101 as AnyObject
  var bedroomWallID: AnyObject = 101 as AnyObject

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
//    foo()
    bar()
  }
    func bar(){
        do {
        let fileManager = FileManager.default
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.stringByAppendingString("/profile.plist")
        
        if(fileManager.fileExists(atPath: path)){
            print(path)
            try fileManager.removeItem(atPath: path)
            
            
            
        }
        let data : [String: String] = [
            "Company": "My Company",
            "FullName": "My Full Name",
            "FirstName": "My First Name",
            "LastName": "My Last Name",
            // any other key values
        ]
        
        let someData = NSDictionary(dictionary: data)
        let isWritten = someData.write(toFile: path, atomically: true)
        print("is the file created: \(isWritten)")
        
            let text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            print(text)
        }catch {print("\(error)")}

    }
  func foo(){
        let dictionary:[String:String] = ["key1" : "value1", "key2":"value2", "key3":"value3"]
    
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docURL = urls[urls.count-1]
    let url = docURL.appendingPathComponent("a.plist")
    if NSKeyedArchiver.archiveRootObject(dictionary, toFile: url.path) {
            print(true)
        }
        
        if let loadedDic = NSKeyedUnarchiver.unarchiveObject(withFile: url.path) as? [String:String] {
            print(loadedDic)   // "["key1": "value1", "key2": "value2", "key3": "value3"]\n"
        }
    do {
        let text = try String(contentsOfFile: url.path, encoding: String.Encoding.utf8)
        print(text)
    }
    catch {print("\(error)")}
  }
  @IBAction func saveButtonTapped(_ sender: AnyObject) {
    //change bedroomFloorID variable value
    bedroomFloorID = 999 as AnyObject
    //save the plist with the changes
//    saveGameData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
// func loadGameData() {
//    do{
//    // getting path to GameData.plist
//    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
//    let documentsDirectory = paths[0] as! String
//    let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist")
//    
//    let fileManager = FileManager.default
//    
//    //check if file exists
//    if(!fileManager.fileExists(atPath: path)) {
//      // If it doesn't, copy it from the default file in the Bundle
//      if let bundlePath = Bundle.main.path(forResource: "GameData", ofType: "plist") {
//        
//        let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
//        print("Bundle GameData.plist file is --> \(resultDictionary?.description)")
//        
//        try fileManager.copyItem(atPath: bundlePath, toPath: path)
//        print("copy")
//      } else {
//        print("GameData.plist not found. Please, make sure it is part of the bundle.")
//      }
//    } else {
//      print("GameData.plist already exits at path.")
//      // use this to delete file from documents directory
//      //fileManager.removeItemAtPath(path, error: nil)
//    }
//    
//    let resultDictionary = NSMutableDictionary(contentsOfFile: path)
//    print("Loaded GameData.plist file is --> \(resultDictionary?.description)")
//    
//    var myDict = NSDictionary(contentsOfFile: path)
//    
//    if let dict = myDict {
//      //loading values
//      bedroomFloorID = dict.object(forKey: BedroomFloorKey)! as AnyObject
//      bedroomWallID = dict.object(forKey: BedroomWallKey)! as AnyObject
//      //...
//    } else {
//      print("WARNING: Couldn't create dictionary from GameData.plist! Default values will be used!")
//    }
//    }catch{}
//  }
//  
//  func saveGameData() {
//    
//    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
//    let documentsDirectory = paths.object(at: 0) as! NSString
//    let path = documentsDirectory.appendingPathComponent("GameData.plist")
//    
//    var dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
//    //saving values
//    dict.setObject(bedroomFloorID, forKey: BedroomFloorKey as NSCopying)
//    dict.setObject(bedroomWallID, forKey: BedroomWallKey as NSCopying)
//    //...
//    
//    //writing to GameData.plist
//    dict.write(toFile: path, atomically: false)
//    
//    let resultDictionary = NSMutableDictionary(contentsOfFile: path)
//    print("Saved GameData.plist file is --> \(resultDictionary?.description)")
//    
//  }

}

