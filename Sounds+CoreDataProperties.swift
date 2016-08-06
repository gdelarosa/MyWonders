//
//  Sounds+CoreDataProperties.swift
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

extension Sounds {

    @NSManaged var wonderName: String?
    @NSManaged var wonderSoundTitle: String?
    @NSManaged var wonderSoundURL: String?

}
