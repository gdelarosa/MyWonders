//
//  PhotosViewController.swift
//  MyWonders
//
//  Created by Gina De La Rosa on 8/1/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import MobileCoreServices

class PhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var addimageSwitchLabel: UISwitch!
    @IBOutlet weak var saveImageConfirmation: UILabel!
    @IBOutlet weak var wonderImage: UIImageView!
    
    var photosWonderName: String!
    var photosSourceType: String! // Decalre var library or camera to be used for incoming segue
   
    @IBAction func addWonderPhotoAction(sender: AnyObject) {
        accessCameraOrPhotoLibrary() // Plus button on right // Accessing function from below.
        
    }
    
    @IBAction func addImageToCoreDataAction(sender: AnyObject) {
        addImageToCoreData()
   
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addImageLabel.text = photosWonderName
        addimageSwitchLabel.alpha = 0
        saveImageConfirmation.alpha = 0
        
        accessCameraOrPhotoLibrary()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Code to select from PhotoLibrary
    func accessCameraOrPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if photosSourceType == "Photos" {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
                presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) { //delegate to cancel photo selection from library
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqualToString(kUTTypeImage as NSString as String) { // Media is an image
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            wonderImage.image = image
            wonderImage.contentMode = .ScaleAspectFit
            
        } // End of mediaType is Image
        
        addImageLabel.alpha = 1
        addimageSwitchLabel.alpha = 1
        addimageSwitchLabel.setOn(true, animated: true)
        saveImageConfirmation.alpha = 0
        addImageToCoreData()
        
    }
    
    func addImageToCoreData() {
    
    let photosAppDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let photosContext:NSManagedObjectContext = photosAppDel.managedObjectContext
    
    if addimageSwitchLabel.on {
    let newImageData = UIImageJPEGRepresentation(wonderImage.image!, 1) //binary data object of photo image
    let newPhoto = NSEntityDescription.insertNewObjectForEntityForName("Photos", inManagedObjectContext: photosContext) as! Photos
    
    newPhoto.wonderName = photosWonderName
    newPhoto.wonderPhoto = newImageData
    
        do {
            try photosContext.save()
            saveImageConfirmation.alpha = 1
            saveImageConfirmation.text = "Saved Photo of: " + photosWonderName
    }   catch _ {
                }
    }
    
    }

}
