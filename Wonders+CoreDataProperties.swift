//
//  Wonders+CoreDataProperties.swift
//  MyWonders
//
//  Created by Gina De La Rosa on 7/30/16.
//  Copyright © 2016 Gina De La Rosa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Wonders {

    @NSManaged var wonderName: String
    @NSManaged var wonderType: String
    @NSManaged var wonderNotes: String
    @NSManaged var wonderShow: NSNumber
    @NSManaged var wonderLatitude: NSNumber
    @NSManaged var wonderLongitude: NSNumber

}
