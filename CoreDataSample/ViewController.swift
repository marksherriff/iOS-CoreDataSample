//
//  ViewController.swift
//  CoreDataSample
//
//  Created by sherriff on 10/27/15.
//  Copyright © 2015 Mark Sherriff. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITextFieldDelegate{
    
    // MARK: Properties
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    var controller:UIAlertController?
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let prefs = NSUserDefaults.standardUserDefaults()
        self.textField.delegate = self
        self.age.delegate = self
        self.lastName.delegate = self
        self.firstName.delegate = self
        do {
            let path = NSTemporaryDirectory() + "savedText.txt"
        
            let readString = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            textLabel.text = readString
        } catch let error as NSError {
            textLabel.text = "No file saved yet!"
            print(error)
        }
        
        if let savedText = prefs.stringForKey("savedText"){
            print("NSUserDefaults contains: " + savedText)
        }else{
            //Nothing stored in NSUserDefaults yet. Set a value.
            print("Nothing stored yet in NSUserDefaults")
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
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setValue(someText, forKey: "savedText")
        
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
    func createNewPersonWithFirstName(firstName: String,
        lastName :String,
        age: Int) -> Bool{
            
            let newPerson =
            NSEntityDescription.insertNewObjectForEntityForName("Person",
                inManagedObjectContext: managedObjectContext) as! CoreDataSample.Person
            
            (newPerson.firstName, newPerson.lastName, newPerson.age) =
                (firstName, lastName, age)
            
            do{
                try managedObjectContext.save()
            } catch let error as NSError{
                print("Failed to save the new person. Error = \(error)")
            }
            
            return false
            
    }
    @IBAction func savePerson(sender: UIButton) {
        createNewPersonWithFirstName(firstName.text!,lastName:  lastName.text!,age:  Int(age.text!)!)
        showAlert(firstName.text! + " " + lastName.text!)
        
    }
    @IBAction func loadPerson(sender: UIButton) {
        
        var first = true
        
        /* Create the fetch request first */
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        let ageSort = NSSortDescriptor(key: "age", ascending: true)
        
        let firstNameSort = NSSortDescriptor(key: "firstName", ascending: true)
        
        fetchRequest.sortDescriptors = [ageSort, firstNameSort]
        
        /* And execute the fetch request on the context */
        do{
            let persons = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Person]
            for person in persons{
                if(first) {
                    firstName.text = person.firstName
                    lastName.text = person.lastName
                    age.text = String(person.age)
                    first = false
                }
                
                print("First Name = \(person.firstName)")
                print("Last Name = \(person.lastName)")
                print("Age = \(person.age)")
                
            }
        } catch let error as NSError{
            print(error)
        }
    }
}

