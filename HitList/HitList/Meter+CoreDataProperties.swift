//
//  Meter+CoreDataProperties.swift
//  HitList
//
//  Created by zeeshan on 10/12/17.
//  Copyright © 2017 Razeware. All rights reserved.
//
//

import Foundation
import CoreData


extension Meter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meter> {
        return NSFetchRequest<Meter>(entityName: "Meter")
    }

    @NSManaged public var nameOfEquipment: String?
    @NSManaged public var equipmentId: String?
    @NSManaged public var location: String?
    @NSManaged public var units: String?
    @NSManaged public var minValue: String?
    @NSManaged public var maxValue: String?
    @NSManaged public var formulae: String?
    @NSManaged public var inputValues: String?
    @NSManaged public var outputValues: String?
    @NSManaged public var shiftTime: String?
    @NSManaged public var readings: String?
    @NSManaged public var notes: String?
    @NSManaged public var recordedBy: String?
    @NSManaged public var instructions: String?

}
