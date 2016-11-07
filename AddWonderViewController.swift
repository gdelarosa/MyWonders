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
    @IBOutlet weak var cameraButtonLabel: UIButton!
    @IBOutlet weak var soundsButtonLabel: UIButton!
    
    var wonderName:String = "" // It will be empty.
    var wonderLatitude:Double = 0.0
    var wonderLongitude:Double = 0.0
    var wonderNotes:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let saveRightBarButton = UIBarButtonSystemItem.save
        
        navigationItem.rightBarButtonItem = UIBarButtonItem( //Programatically adds a save button on the right side of the screen.
        barButtonSystemItem: saveRightBarButton,
        target: self, action: #selector(AddWonderViewController.addSaveButtonAction(_:)))
        
        saveConfirmationLabel.alpha = 0
        
        wonderTextView.text = ".."
        self.wonderNameTextField.delegate = self
        photosButtonLabel.alpha = 0
        cameraButtonLabel.alpha = 0
        soundsButtonLabel.alpha = 0
    }
    
    @IBAction func addSaveButtonAction(_ sender: AnyObject) { // Need to add this action for Save button.
        
        wonderName = wonderNameTextField.text!
        wonderLatitude = Double(wonderLatitudeTextField.text!) ?? 0.0
        wonderLongitude = Double(wonderLongitudeTextField.text!) ?? 0.0
        wonderNotes = wonderTextView.text!
        
        //Code below will save the wonder record to Core Data// 
        
        let wondersAppDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let wondersContext:NSManagedObjectContext = wondersAppDel.managedObjectContext
        let newWonder = NSEntityDescription.insertNewObject(forEntityName: "Wonders", into: wondersContext) as! Wonders // added "as! Wonders" class 
        
        newWonder.wonderName = wonderName
//        newWonder.wonderLatitude = NSNumber(wonderLatitude))
//        newWonder.wonderLongitude = NSNumber(wonderLongitude)
        newWonder.wonderShow = true
        newWonder.wonderType = "MY"
        newWonder.wonderNotes = wonderTextView.text 
        
        do { // Will save information if not it will give an error message.
            try wondersContext.save()
            saveConfirmationLabel.alpha = 1
            saveConfirmationLabel.text = "Saved:" + wonderName
            
            photosButtonLabel.alpha = 1
            cameraButtonLabel.alpha = 1
            soundsButtonLabel.alpha = 1
            
        } catch {
            saveConfirmationLabel.alpha = 1 
            saveConfirmationLabel.text = "Error:" + wonderName
            print("Could not save \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // Prepare for Segue to Photos, Camera, and Sounds to pass wonder name value
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "addToPhotos" {
            
            let vc = segue.destination as! PhotosViewController
            vc.photosWonderName = wonderName //the new vc var = this vc var
            vc.photosSourceType = "Photos" //the new vc var = this vc var
        }
        
        if segue.identifier == "addToCamera" {
            
            let vc = segue.destination as! PhotosViewController
            vc.photosWonderName = wonderName //the new vc var = this vc var
            vc.photosSourceType = "Camera" //the new vc var = this vc var
        }
        
        if segue.identifier == "addToSounds" {
            
            let vc = segue.destination as! SoundsViewController
            vc.soundsWonderName = wonderName
        }

    
    }
    
    // Keyboard Control 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        wonderNameTextField.resignFirstResponder()
        return false;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

  

}
