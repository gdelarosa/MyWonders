//
//  VideosViewController.swift
//  MyWonders
//
//  Created by Gina De La Rosa on 8/20/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//
//
//import UIKit
//import CoreData
//import MobileCoreServices
//import AVKit
//import Photos
//import MediaPlayer
//
//class VideosViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    
//    var videoController = UIImagePickerController()
//    var assetsLibrary = PHPhotoLibrary()
//    var moviePlayer : AVPlayerViewController?
//    
//    var videosWonderName: String!
//    var videosSourceType: String!
//    var videoURLText: String! //Store video URL in a text string
//    
//    @IBOutlet weak var addVideoToLabel: UILabel!
//    @IBOutlet weak var addVideoConfirmationLabel: UILabel!
//    @IBOutlet weak var addVideoURL: UILabel!
//    @IBOutlet weak var addVideosSwitchOutlet: UISwitch!
//    @IBOutlet weak var addVideosNoLabel: UILabel!
//    @IBOutlet weak var addVideoYesLabel: UILabel!
//    
//    @IBAction func recordVideoButton(sender: UIButton) {
//        
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            videoController.sourceType = .camera
//            videoController.mediaTypes = [kUTTypeMovie as String]
//            videoController.delegate = self
//            
//            present(videoController, animated: true, completion: nil)
//        }
//        else {
//            noCamera()
//        }
//    }
//    
//    func noCamera() {
//    
//        let alertVC = UIAlertController(title: "No Camera!", message: "Device does not have Camera", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertVC.addAction(okAction)
//        present(alertVC, animated: true, completion: nil)
//}
//    
//    @IBAction func viewLibraryButton(sender: UIButton) {
//        
//        videoController.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        videoController.mediaTypes = [kUTTypeMovie as String]
//        videoController.delegate = self
//        
//        present(videoController, animated: true, completion: nil)
//    }
//    
//   
//    @IBAction func playVideoButton(sender: UIButton) {
//        playVideo()
//        
//    }
//    
////    func playVideo() {
////        if videoURLText != nil {
////            if let url = NSURL(string: self.videoURLText!) {
////                moviePlayer = AVPlayerViewController(coder: url as URL! as URL!)
////                if let player = moviePlayer {
////                    player.view.frame = self.view.bounds //fits whole screen
////                    player.controlStyle = PHControlStyle.fullscreen
////                    player.scalingMode = .aspectFit
////                    
////                    player.prepareToPlay()
////                    player.play()
////                    self.view.addSubview(player.view)
////                    
////                    addVideosSwitchOutlet.alpha = 1
////                    addVideosSwitchOutlet.setOn(false, animated: true)
////                }
////            }
////        }
////    }
//    
//    @IBAction func addVideoSwitchAction(sender: UISwitch) {
//        
//        let videosAppDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        let videosContext: NSManagedObjectContext = videosAppDel.managedObjectContext
//        let videosEntity = NSEntityDescription.entity(forEntityName: "Videos", in: videosContext)
//        
//        let videoURL = NSURL(string: self.videoURLText!)
//        let videoURLString = videoURL!.absoluteString
//        // if ON, Store video in Videos CoreData, else delete from Core data (if exists)
//        if addVideosSwitchOutlet.isOn {
//          let newVideo = NSManagedObject(entity: videosEntity!, insertInto: videosContext) as! Videos
//            newVideo.wonderName = videosWonderName
//            newVideo.wonderVideoURL = videoURLString
//            do {
//                try videosContext.save()
//                addVideoConfirmationLabel.alpha = 1
//                addVideoConfirmationLabel.textColor = UIColor(red: 20/255, green: 180/255, blue: 24/255, alpha: 1.0)
//                addVideoConfirmationLabel.text = "Saved Video of: " + videosWonderName
//            } catch _ {
//            }
//            addVideoToLabel.text = videosWonderName
//            addVideoToLabel.textColor = UIColor.blue
//        }
//        
//        else {
//            let requestVideoDelete = NSFetchRequest<NSFetchRequestResult>(entityName: "Videos")
//            requestVideoDelete.returnsObjectsAsFaults = false
//            requestVideoDelete.predicate = NSPredicate(format: "wonderName = %@", videosWonderName)
//            requestVideoDelete.predicate = NSPredicate(format: "wonderVideoURL = %@", videoURLString!)
//            
//            let videoRecordsToDelete = try? videosContext.fetch(requestVideoDelete)
//            
//            if (videoRecordsToDelete?.count)! > 0 {
//                for videoRecordsToDelete: AnyObject in videoRecordsToDelete! {
//                    videosContext.deleteObject(videoRecordsToDelete as! Videos)
//                }
//            }
//            do {
//                try videosContext.save()
//                addVideoConfirmationLabel.textColor = UIColor.red
//                addVideoConfirmationLabel.text = "Removed Video of: " + videosWonderName
//            } catch _ {
//            }
//        }
//        
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        addVideoURL.alpha = 0
//        addVideoYesLabel.alpha = 0
//        addVideosNoLabel.alpha = 0
//        addVideosSwitchOutlet.alpha = 0
//        videosWonderName = "Testing Videos"
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        
//    }
//    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
//        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
//        if let type:AnyObject = mediaType {
//            if type is String {
//                let stringType = type as! String
//                if stringType == kUTTypeMovie as String {
//                    let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
//                    if let url = urlOfVideo {
//                        assetsLibrary.writeVideoAtPathToSavedPhotosAlbum(url as URL!, completionBlock: {(url: NSURL!, error: NSError!) in
//                            if let theError = error{
//                                print("Error saving video= \(theError)")
//                            }
//                            
//                            else {
//                                let urlString = url.absoluteString
//                                self.videoURLText = urlString
//                                self.addVideoURL.text = "Save Video for " + self.videosWonderName + "?"
//                                self.addVideoURL.textColor = UIColor.blueColor()
//                            }
//                    })
//                }
//            }
//        }
//    }
//        picker.dismiss(animated: true, completion: nil)
//        
//        addVideoToLabel.alpha = 1
//        addVideoURL.alpha = 1
//        addVideosNoLabel.alpha = 1
//        addVideoYesLabel.alpha = 1
//        addVideosSwitchOutlet.alpha = 1
//        addVideosSwitchOutlet.setOn(false, animated: true)
//        addVideoConfirmationLabel.alpha = 0
//        
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


