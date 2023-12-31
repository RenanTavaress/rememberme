//
//  AppDelegate.swift
//  rememberme
//
//  Created by Renan Tavares on 19/07/23.
//

import UIKit
import CoreData
import AVFAudio

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
    
    var persistentContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: "ScheduleCoreData") // Substitua "NomeDoModeloDeDados" pelo nome do seu arquivo .xcdatamodeld
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Erro ao configurar o Core Data: \(error.localizedDescription)")
            }
        }
        return container
    }
    
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Erro ao salvar o contexto do Core Data: \(nserror.localizedDescription)")
            }
        }
    }
    
    
}

