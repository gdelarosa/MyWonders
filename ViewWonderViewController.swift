//
//  ViewWonderViewController.swift
//  MyWonders
//
//  Created by Gina De La Rosa on 7/30/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class ViewWonderViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var wonderNameLabel: UILabel!
    @IBOutlet weak var wonderLatitudeLabel: UILabel!
    @IBOutlet weak var wonderLongitudeLabel: UILabel!
    @IBOutlet weak var wonderTextView: UITextView!
    @IBOutlet weak var wonderMapView: MKMapView! //Connect Map to Outlet
    @IBOutlet weak var wonderImageButtonOutlet: UIButton!
    @IBOutlet weak var numberOfPhotosLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       wonderNameLabel.text = viewSelectedWonderName
        
        // CODE FOR MAP LONGITUDE AND LATITUDE // 
        
        let cellLatitudeDouble:Double = viewSelectedWonderLatitude as Double!
        let cellLatitudeString:String = String(format:"%.6f", cellLatitudeDouble)
        
        let cellLongitudeDouble:Double = viewSelectedWonderLongitude as Double!
        let cellLongitudeString:String = String(format: "%.6f", cellLongitudeDouble)
        
        wonderLatitudeLabel.text = cellLatitudeString
        wonderLongitudeLabel.text = cellLongitudeString
        wonderTextView.text = viewSelectedWonderNotes
        
        let latitude: CLLocationDegrees = viewSelectedWonderLatitude
        let longitude: CLLocationDegrees = viewSelectedWonderLongitude
        let deltaLatutude: CLLocationDegrees = 0.01
        let deltaLongitude: CLLocationDegrees = 0.01
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(deltaLatutude, deltaLongitude)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        wonderMapView.setRegion(region, animated: true)
        
        // Code for Pins with text bubbles on the map. Define annotation coordinates then text title // 
        
        let wonderAnnotation = MKPointAnnotation()
        wonderAnnotation.coordinate = location
        wonderAnnotation.title = viewSelectedWonderName
        
        wonderMapView.addAnnotation(wonderAnnotation) 
    }
    
    override func viewDidAppear(animated: Bool) {
        //Get image Data from Core Data
        let photosAppDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let photosContext:NSManagedObjectContext = photosAppDel.managedObjectContext
        let photosFetchRequest = NSFetchRequest(entityName:"Photos")
        
        //Create a predicate that selects on the "wonderName" property of the Core Data object 
        photosFetchRequest.predicate = NSPredicate(format: "wonderName = %@", viewSelectedWonderName)
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
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    

}