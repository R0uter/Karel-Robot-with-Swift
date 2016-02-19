//
//  ConfigData+CoreDataProperties.swift
//  Karel Robot with Swift2
//
//  Created by R0uter on 16/2/19.
//  Copyright © 2016年 R0uter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ConfigData {

    @NSManaged var direction: String?
    @NSManaged var coordinate: String?
    @NSManaged var blockSet: String?
    @NSManaged var beeperSet: String?

}
