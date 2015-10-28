//
//  ViewController.swift
//  CoreDataSample
//
//  Created by sherriff on 10/27/15.
//  Copyright © 2015 Mark Sherriff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textLabel: UILabel!
    
    var controller:UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let path = NSTemporaryDirectory() + "savedText.txt"
        
            let readString = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            textLabel.text = readString
        } catch let error as NSError {
            textLabel.text = "No file saved yet!"
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func saveButton(sender: UIButton) {
        let someText = textField.text!
        let destinationPath = NSTemporaryDirectory() +  "savedText.txt"
        do {
            try someText.writeToFile(destinationPath,
                atomically: true,
                encoding: NSUTF8StringEncoding)
            showAlert(someText)
            print("Successfully stored the file at path \(destinationPath)")
        } catch let error as NSError {
            print("An error occurred: \(error)")
        }
        
    }
    
    func showAlert(text: NSString) {
        controller = UIAlertController(title: "Saved Text",
            message: (text as String) + " was saved!",
            preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "Done",
            style: UIAlertActionStyle.Default,
            handler: {(paramAction:UIAlertAction!) in
                print((text as String) + " was saved!", terminator: "")
        })
        
        controller!.addAction(action)
        self.presentViewController(controller!, animated: true, completion: nil)
    }
}

