//
//  ScheduleCoreData+CoreDataProperties.swift
//  rememberme
//
//  Created by Renan Tavares on 29/11/23.
//
//

import Foundation
import CoreData


extension ScheduleCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleCoreData> {
        return NSFetchRequest<ScheduleCoreData>(entityName: "ScheduleCoreData")
    }

    @NSManaged public var startDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var endDate: Date?

}

extension ScheduleCoreData : Identifiable {

}
