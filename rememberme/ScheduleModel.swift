//
//  Schedule.swift
//  rememberme
//
//  Created by Renan Tavares on 07/08/23.
//

import Foundation
import UIKit
import CoreData

@objc(ScheduleModel)
class ScheduleModel: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var scheduleName: String
    @NSManaged var dateSchedule: Date
    
    convenience init(scheduleName: String, dateSchedule: Date) {
        let contexto = UIApplication.shared.delegate as! AppDelegate
        self.init(context: contexto.persistentContainer.viewContext)
        
        self.id = UUID()
        self.scheduleName = scheduleName
        self.dateSchedule = dateSchedule
    }
}

extension ScheduleModel {
    func save(_ contexto: NSManagedObjectContext){
        
        guard let contexto = self.managedObjectContext else {
            return
        }
        do {
            if contexto.hasChanges {
                try contexto.save()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
