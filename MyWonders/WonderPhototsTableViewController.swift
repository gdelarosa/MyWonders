//
//  WonderPhototsTableViewController.swift
//  MyWonders
//
//  Created by Gina De La Rosa on 8/2/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import CoreData


class WonderPhototsTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var wonderPhotosArray: [Photos] = [] // array to hold 1 wonder multiple photos

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let wonderPhotosAppDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let wonderPhotosContext:NSManagedObjectContext = wonderPhotosAppDel.managedObjectContext
        let wonderPhotosFetchRequest = NSFetchRequest(entityName: "Photos")
        
        //Create a predicate that selects on the "wonderName" property of the Core Data object 
        wonderPhotosFetchRequest.predicate = NSPredicate(format: "wonderName = %@", viewSelectedWonderName) //select 1 wonder record only 
        
        do {
            let wonderPhotosFetchResults = try wonderPhotosContext.fetch(wonderPhotosFetchRequest) as? [Photos]
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wonderPhotosArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WonderPhotoCell", for: indexPath)
        
        let wonderPhoto: Photos = wonderPhotosArray[(indexPath as NSIndexPath).row]
        let wonderPhotoName = wonderPhoto.wonderName
        let wonderPhotoImage = UIImage(data: wonderPhoto.wonderPhoto! as Data)
        
        if let nameLabel = cell.viewWithTag(101) as? UILabel {
            nameLabel.text = wonderPhotoName
        }
        
        if let wonderPhotoImageView = cell.viewWithTag(100) as? UIImageView {
            wonderPhotoImageView.image = wonderPhotoImage
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height;
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
