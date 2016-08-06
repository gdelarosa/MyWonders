//
//  WondersTableViewController.swift
//  MyWonders
//
//  Created by Gina De La Rosa on 7/30/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import CoreData

var viewSelectedWonderName:String = ""
var viewSelectedWonderLatitude:Double = 0.0
var viewSelectedWonderLongitude:Double = 0.0
var viewSelectedWonderNotes:String = ""

var editSelectedRow: Int = 0
var editSelectedWonderName:String = ""
var editSelectedWonderLatitude:Double = 0.0
var editSelectedWonderLongitude:Double = 0.0
var editSelectedWonderNotes:String = ""


class WondersTableViewController: UITableViewController {
    
    var wonders = [Wonders]() // want to make sure you access wonders class

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem() // EDIT BUTTON
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let wondersAppDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let wondersContext:NSManagedObjectContext = wondersAppDel.managedObjectContext
        let wonderFetchRequest = NSFetchRequest(entityName: "Wonders")
        wonderFetchRequest.predicate = NSPredicate(format: "wonderShow = %@", true)
        let sortDescriptor = NSSortDescriptor(key: "wonderName", ascending: true)
        wonderFetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            if let wonderFetchedResults = try wondersContext.executeFetchRequest(wonderFetchRequest) as? [Wonders] {
                wonders = wonderFetchedResults
            } else {
                print("ELSE if let results = try...Failed")
            }
            
        } catch {
            fatalError("There was an error fetching the list of groups!")
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wonders.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WondersCell", forIndexPath: indexPath)

        // Configure the cell...
        
        let wonder = wonders[indexPath.row]
        cell.textLabel?.text = wonder.wonderName
        
        let cellLatitudeDouble:Double = wonder.wonderLatitude as Double!
        let cellLatitudeString:String = String(format:"%.6f", cellLatitudeDouble)
        
        let cellLongitudeDouble:Double = wonder.wonderLongitude as Double!
        let cellLongitudeString:String = String(format:"%.6f", cellLongitudeDouble)
        
        cell.detailTextLabel?.text = "Lat: " + cellLatitudeString + " Lon: " + cellLongitudeString
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            let wondersAppDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let wondersContext:NSManagedObjectContext = wondersAppDel.managedObjectContext
            
            wondersContext.deleteObject(wonders[indexPath.row] as Wonders) // Delete from Core Data
            
            do {
                try wondersContext.save()
            } catch {
                print("Could not delete \(error)")
            }
            
            wonders.removeAtIndex(indexPath.row) // Delete from Array of Wonders
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let wonder = wonders[indexPath.row]
        viewSelectedWonderName = wonder.wonderName
        viewSelectedWonderLatitude = wonder.wonderLatitude as Double
        viewSelectedWonderLongitude = wonder.wonderLongitude as Double
        viewSelectedWonderNotes = wonder.wonderNotes 
        
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let wonder = wonders[indexPath.row]
        editSelectedRow = indexPath.row
        editSelectedWonderName = wonder.wonderName
        editSelectedWonderLatitude = wonder.wonderLatitude as Double
        editSelectedWonderLongitude = wonder.wonderLongitude as Double
        editSelectedWonderNotes = wonder.wonderNotes
        
    }

    
}
