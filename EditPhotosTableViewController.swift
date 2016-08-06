//
//  EditPhotosTableViewController.swift
//  MyWonders
//
//  Created by Gina De La Rosa on 8/5/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import CoreData

let wonderPhotosAppDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let wonderPhotosContext:NSManagedObjectContext = wonderPhotosAppDel.managedObjectContext
let wonderPhotosFetchRequest = NSFetchRequest(entityName: "Photos")

class EditPhotosTableViewController: UITableViewController, UINavigationControllerDelegate {
        
        var wonderPhotosArray: [Photos] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        //Create a predicate that selects on the "wonderName" property of the Core Data object
        wonderPhotosFetchRequest.predicate = NSPredicate(format: "wonderName = %@", editSelectedWonderName) //select 1 wonder record only
        
        do {
            let wonderPhotosFetchResults = try wonderPhotosContext.executeFetchRequest(wonderPhotosFetchRequest) as? [Photos]
            wonderPhotosArray = wonderPhotosFetchResults!
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
        return wonderPhotosArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EditPhotoCell", forIndexPath: indexPath)

        let wonderPhoto: Photos = wonderPhotosArray[indexPath.row]
        let wonderPhotoImage = UIImage(data: wonderPhoto.wonderPhoto! as NSData)
        

        if let wonderPhotoImageView = cell.viewWithTag(100) as? UIImageView {
            wonderPhotoImageView.image = wonderPhotoImage
        }
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

   
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            wonderPhotosContext.deleteObject(wonderPhotosArray[indexPath.row] as Photos) //delete from Core Data
            var error: NSError?
            do {
                try wonderPhotosContext.save()
            } catch let error1 as NSError {
                error = error1
                print("Could not delete \(error), \(error?.userInfo)")
            }
        }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
    
}