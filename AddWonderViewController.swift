//
//  AddWonderViewController.swift
//  MyWonders
//
//  Created by Gina De La Rosa on 7/30/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import CoreData

class AddWonderViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var saveConfirmationLabel: UILabel!
    @IBOutlet weak var wonderNameTextField: UITextField!
    @IBOutlet weak var wonderLatitudeTextField: UITextField!
    @IBOutlet weak var wonderLongitudeTextField: UITextField!
    @IBOutlet weak var wonderTextView: UITextView!
    @IBOutlet weak var photosButtonLabel: UIButton!
    
    var wonderName:String = "" // It will be empty.
    var wonderLatitude:Double = 0.0
    var wonderLongitude:Double = 0.0
    var wonderNotes:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let saveRightBarButton = UIBarButtonSystemItem.Save
        
        navigationItem.rightBarButtonItem = UIBarButtonItem( //Programatically adds a save button on the right side of the screen.
        barButtonSystemItem: saveRightBarButton,
        target: self, action: #selector(AddWonderViewController.addSaveButtonAction(_:)))
        
        saveConfirmationLabel.alpha = 0
        
        wonderTextView.text = ".."
        self.wonderNameTextField.delegate = self
        photosButtonLabel.alpha = 0
    }
    
    @IBAction func addSaveButtonAction(sender: AnyObject) { // Need to add this action for Save button.
        
        wonderName = wonderNameTextField.text!
        wonderLatitude = Double(wonderLatitudeTextField.text!) ?? 0.0
        wonderLongitude = Double(wonderLongitudeTextField.text!) ?? 0.0
        wonderNotes = wonderTextView.text!
        
        //Code below will save the wonder record to Core Data// 
        
        let wondersAppDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let wondersContext:NSManagedObjectContext = wondersAppDel.managedObjectContext
        let newWonder = NSEntityDescription.insertNewObjectForEntityForName("Wonders", inManagedObjectContext: wondersContext) as! Wonders // added "as! Wonders" class 
        
        newWonder.wonderName = wonderName
        newWonder.wonderLatitude = wonderLatitude
        newWonder.wonderLongitude = wonderLongitude
        newWonder.wonderShow = true
        newWonder.wonderType = "MY"
        newWonder.wonderNotes = wonderTextView.text 
        
        do { // Will save information if not it will give an error message.
            try wondersContext.save()
            saveConfirmationLabel.alpha = 1
            saveConfirmationLabel.text = "Saved:" + wonderName
            
            photosButtonLabel.alpha = 1
            
        } catch {
            saveConfirmationLabel.alpha = 1 
            saveConfirmationLabel.text = "Error:" + wonderName
            print("Could not save \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // Prepare for Segue to Photos to pass wonder name value
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "addToPhotos" {
            
            let vc = segue.destinationViewController as! PhotosViewController
            vc.photosWonderName = wonderName //the new vc var = this vc var
            vc.photosSourceType = "Photos" //the new vc var = this vc var
        }
    
    }
    
    // Keyboard Control 
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        wonderNameTextField.resignFirstResponder()
        return false;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

  

}
