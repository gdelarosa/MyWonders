//
//  WonderSoundsTableViewController.swift
//  MyWonders
//
//  Created by Gina De La Rosa on 8/8/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class WonderSoundsTableViewController: UITableViewController, UINavigationControllerDelegate, AVAudioPlayerDelegate {
    
    var wonderSoundsArray: [Sounds] = []
    var wonderSoundsName: String!
    
    var error: NSError? = nil
    var soundPlayer: AVAudioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        let wonderSoundsAppDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let wondersSoundsContext: NSManagedObjectContext = wonderSoundsAppDel.managedObjectContext
        let wonderSoundsFetchRequest = NSFetchRequest(entityName: "Sounds")
        //Create predicate that selects on the "wonderName" property of the core data object
        wonderSoundsFetchRequest.predicate = NSPredicate(format: "wonderName = %@", wonderSoundsName)
        
        do {
            let wonderSoundsFetchResults =
            try wondersSoundsContext.executeFetchRequest(wonderSoundsFetchRequest) as? [Sounds]
            
            wonderSoundsArray = wonderSoundsFetchResults!
        } catch {
            print("Could not fetch \(error)")
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wonderSoundsArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WonderSoundCell", forIndexPath: indexPath)
        
        let wonderSound: Sounds = wonderSoundsArray[indexPath.row] as Sounds

        cell.textLabel?.text = wonderSound.wonderSoundTitle
        cell.detailTextLabel?.text = wonderSound.wonderName

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let wonderSound: Sounds = wonderSoundsArray[indexPath.row] as Sounds
        let wonderSoundURL = wonderSound.wonderSoundURL
        
        let directoryURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first
        let audioFileURL = directoryURL!.URLByAppendingPathComponent(wonderSoundURL!)
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOfURL: audioFileURL)
        } catch let error1 as NSError {
            error = error1
        }
        soundPlayer.play()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let wonderSoundsAppDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let wonderSoundsContext:NSManagedObjectContext = wonderSoundsAppDel.managedObjectContext
            
            wonderSoundsContext.deleteObject(wonderSoundsArray[indexPath.row] as Sounds) // Delete from core data
            
            var error:NSError?
            do {
                try wonderSoundsContext.save()
            } catch let error1 as NSError {
                error = error1
                print("Could not delete \(error), \(error?.userInfo)")
            }
            
            wonderSoundsArray.removeAtIndex(indexPath.row) //Delete from array
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

}
