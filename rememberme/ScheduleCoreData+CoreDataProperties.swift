//
//  ScheduleCoreData+CoreDataProperties.swift
//  rememberme
//
//  Created by Renan Tavares on 13/10/23.
//
//

import Foundation
import CoreData


extension ScheduleCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleCoreData> {
        return NSFetchRequest<ScheduleCoreData>(entityName: "ScheduleCoreData")
    }

    @NSManaged public var dateSchedule: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var scheduleName: String?

}

extension ScheduleCoreData : Identifiable {

}
