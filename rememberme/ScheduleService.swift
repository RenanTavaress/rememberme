////
////  ScheduleModel.swift
////  rememberme
////
////  Created by Renan Tavares on 11/09/23.
////
//
//import Foundation
//
//
//struct ScheduleService {
//    
//    var coreDataManager = CoreDataManager.shared
//    
//    func fetchSchedules() -> [ScheduleCoreData] {
//        var schedules = [ScheduleCoreData]()
//        
//        do {
//            let request = ScheduleCoreData.fetchRequest()
//            schedules = try coreDataManager.managedObjectContext.fetch(request)
//            print(schedules)
//            return schedules
//        } catch {
//            return []
//        }
//    }
//    
//    
//    func createPlant(name: String, date: Date){
//        let schedules = ScheduleCoreData(context: coreDataManager.managedObjectContext)
//        schedules.scheduleName = name
//        schedules.dateSchedule = date
//        
//        coreDataManager.saveContext()
//    }
//}
