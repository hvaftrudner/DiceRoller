//
//  CoreDataResult+CoreDataProperties.swift
//  DiceRoller
//
//  Created by Kristoffer Eriksson on 2021-05-16.
//
//

import Foundation
import CoreData


extension CoreDataResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataResult> {
        return NSFetchRequest<CoreDataResult>(entityName: "CoreDataResult")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var result: Int16
    //@NSManaged public var dice: CoreDataDice?
    @NSManaged public var dice: NSSet?
    
    public var diceArray: [CoreDataDice]{
        let set = dice as? Set<CoreDataDice> ?? []
        
        return set.sorted{
            $0.roll > $1.roll
        }
    }

}

extension CoreDataResult : Identifiable {

}
