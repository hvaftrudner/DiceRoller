//
//  CoreDataDice+CoreDataProperties.swift
//  DiceRoller
//
//  Created by Kristoffer Eriksson on 2021-05-16.
//
//

import Foundation
import CoreData


extension CoreDataDice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataDice> {
        return NSFetchRequest<CoreDataDice>(entityName: "CoreDataDice")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var roll: Int16
    @NSManaged public var sides: Int16
    @NSManaged public var result: CoreDataResult?

}

extension CoreDataDice : Identifiable {

}
