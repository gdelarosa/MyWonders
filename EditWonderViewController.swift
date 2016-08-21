//
//  EditWonderViewController.swift
//  MyWonders
//
//  Created by Gina De La Rosa on 7/30/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import CoreData

class EditWonderViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var editSaveConfirmationLabel: UILabel!
    @IBOutlet weak var wonderNameTextField: UITextField!
    @IBOutlet weak var wonderLatitudeTextField: UILabel!
    @IBOutlet weak var wonderLongitudeTextField: UILabel!
    @IBOutlet weak var wonderNotesTextView: UITextView!
    @IBOutlet weak var wonderImageButtonOutlet: UIButton!
    @IBOutlet weak var numberOfPhotosLabel: UILabel!
    @IBOutlet weak var wonderSoundsButtonOutlet: UIButton!
    @IBOutlet weak var numberOfSoundsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wonderNameTextField.text = editSelectedWonderName
        self.wonderNameTextField.delegate = self; 
        
        let cellLatitudeDouble:Double = editSelectedWonderLatitude as Double!
        let cellLatitudeString:String = String(format:"%.6", cellLatitudeDouble)
        
        let cellLongitudeDouble:Double = editSelectedWonderLongitude as Double!
        let cellLongitudeString:String = String(format:"%.6", cellLongitudeDouble)
        
        wonderLatitudeTextField.text = cellLatitudeString
        wonderLongitudeTextField.text = cellLongitudeString
        wonderNotesTextView.text = editSelectedWonderNotes
        
        editSaveConfirmationLabel.alpha = 0 // Save confirmation label invisible at launch of view
        
        let saveRightBarButton = UIBarButtonSystemItem.Save
        navigationItem.rightBarButtonItem = UIBarButtonItem( //Programatically adds a save button on the right side of the screen.
            barButtonSystemItem: saveRightBarButton,
            target: self, action: #selector(EditWonderViewController.editSaveButtonAction(_:)))
        
//        let saveRightBarButton = UIBarButtonSystemItem.Save
//        navigationItem.rightBarButtonItem = UIBarButtonSystemItem(
//        barButtonSystemItem: saveRightBarButton,
//        target: self, action: "editSaveButtonAction:")
    }
    
    override func viewWillAppear(animated: Bool) {
        //Get image Data from Core Data
        let photosAppDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let photosContext:NSManagedObjectContext = photosAppDel.managedObjectContext
        let photosFetchRequest = NSFetchRequest(entityName:"Photos")
        
        //Create a predicate that selects on the "wonderName" property of the Core Data object
        photosFetchRequest.predicate = NSPredicate(format: "wonderName = %@", editSelectedWonderName)
        var photos: [Photos] = [] // array to hold 1 wonder photos
        do {
            let photosFetchResults = try photosContext.executeFetchRequest(photosFetchRequest) as? [Photos]
            photos = photosFetchResults!
        } catch {
            print("Could not fetch \(error)")
        }
        
        numberOfPhotosLabel.text = String(photos.count)
        
        if photos.count == 0 {
            if let image = UIImage(named: "photo_default") {
                wonderImageButtonOutlet.setImage(image, forState: .Normal)
            }
        } else {
            let photo: Photos = photos[0] // get the 1st photo image
            
            if let thumbnail = UIImage(data: photo.wonderPhoto!) {
                wonderImageButtonOutlet.setImage(thumbnail, forState: .Normal)
            } else {
                if let image = UIImage(named: "photo_default") {
                    wonderImageButtonOutlet.setImage(image, forState: .Normal)
                }
            }
        }
        // Retrieve the sounds entity number of Sounds 
        //Get sounds from core data.
        let soundsAppDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let soundsContext:NSManagedObjectContext = soundsAppDel.managedObjectContext
        
        let soundsFetchRequest = NSFetchRequest(entityName:"Sounds")
        
        //Create a predicate that selects on the "wonderName" property of the Core Data object
        soundsFetchRequest.predicate = NSPredicate(format: "wonderName = %@", editSelectedWonderName)
        var sounds: [Sounds] = [] // array to get sounds
        do {
            let soundsFetchResults = try soundsContext.executeFetchRequest(photosFetchRequest) as? [Sounds]
            sounds = soundsFetchResults!
        } catch {
            print("Could not fetch \(error)")
        }
        
        numberOfSoundsLabel.text = String(sounds.count)
        
        if sounds.count == 0 {
            if let image = UIImage(named: "vol_mute.png") {
                wonderImageButtonOutlet.setImage(image, forState: .Normal)
            }
            } else {
                if let image = UIImage(named: "vol_loud.png") {
                    wonderSoundsButtonOutlet.setImage(image, forState: .Normal)
                }
            }
    }
    
    @IBAction func editSaveButtonAction(sender:AnyObject) {
        
        var wonders = [Wonders]()
        
        let wondersAppDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let wondersContext:NSManagedObjectContext = wondersAppDel.managedObjectContext
        let wonderFetchRequest = NSFetchRequest(entityName: "Wonders")
        do {
            if let wonderFetchedResults = try wondersContext.executeFetchRequest(wonderFetchRequest) as? [Wonders] {
                wonders = wonderFetchedResults
          } else {
            print("ELSE if let results = try... FAILED")
          }
        } catch {
                fatalError("There was an error fetching the list of groups!")
    }
    
    let wonder = wonders[editSelectedRow]
        
    wonder.wonderName = wonderNameTextField.text!
    wonder.wonderLatitude = Double(wonderLatitudeTextField.text!) ?? 0.0
    wonder.wonderLongitude = Double(wonderLongitudeTextField.text!) ?? 0.0
    wonder.wonderNotes = wonderNotesTextView.text
    
        do {
            try wondersContext.save()
            editSaveConfirmationLabel.alpha = 1
            editSaveConfirmationLabel.text = "Saved:" + wonderNameTextField.text!
        } catch {
            editSaveConfirmationLabel.alpha = 1
            editSaveConfirmationLabel.text = "Error:" + wonderNameTextField.text!
            print("Could not save \(error)")
    }
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //Prepare for Segue to Photos to pass wonder name value. 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "editToWonderPhotos" { // Allow edit from Photo
            
            let vc = segue.destinationViewController as! PhotosViewController
            vc.photosWonderName = editSelectedWonderName
            vc.photosSourceType = "Photos"
        }
        
        if segue.identifier == "editToCamera" { // Allows edit from Camera.
            
            let vc = segue.destinationViewController as! PhotosViewController
            vc.photosWonderName = editSelectedWonderName
            vc.photosSourceType = "Camera"
        }
        
        if segue.identifier == "editToSounds" {
            let vc = segue.destinationViewController as! SoundsViewController
            vc.soundsWonderName = editSelectedWonderName
        }
        
        if segue.identifier == "editToWonderSounds" {
            let vc = segue.destinationViewController as! WonderSoundsTableViewController
            vc.wonderSoundsName = editSelectedWonderName
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
