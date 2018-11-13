//
//  Storage.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 13/11/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import Foundation
import CoreData

 class Storage {
    
    var storeUrl:URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
        return documentsUrl.appendingPathComponent("MyStore.sqlite")
    }
    
    let dataModelName = "UserData"
    let dataModelExtension = "momd"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.dataModelName,
                                       withExtension: self.dataModelExtension)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
        } catch {
            assert(false, "Error adding store: \(error)")
        }
        return coordinator
    }()
    
    lazy var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        return masterContext
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        return mainContext
    }()
    
    lazy var saveContext: NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = self.mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        return saveContext
    }()
    
    typealias SaveCompletion = () -> Void
    func performSave (with context: NSManagedObjectContext, completion: SaveCompletion? = nil ) {
        guard context.hasChanges else{ completion?()
            return
        }
        
        context.perform {
            do {
                try context.save()
            } catch {
                print("Context save error: \(error)")
            }
            
            if let parentContext = context.parent {
                self.performSave(with: parentContext, completion: completion)
            } else {
                completion?()
            }
        }
    }

 /* let container = NSPersistentContainer(name: "Storage")
 let sqlite = NSPersistentStoreDescription(url: self.url(for:"Storage.sqlite")!)
 sqlite.type = NSSQLiteStoreType
 container.persistentStoreDescriptions = [sqlite]
 container.loadPersistentStores(completionHandler: { _, error in
     guard let error = error else { return }
     print(error)
 })
 let context = container.viewContext
} */
}

