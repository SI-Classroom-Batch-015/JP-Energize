//
//  PersistentStore.swift
//  JP Energize
//
//  Created by Phillip Wilke on 03.10.24.
//

import Foundation
import CoreData

struct PersistentStore {
    
    static let shared = PersistentStore()
    
    init() {
        container = NSPersistentContainer(name: "Data")
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Error with Core Data: \(error) ,\(error.userInfo)")
            }
        }
    }
    
    
    private let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    
    
    func save() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error as NSError {
            NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
        }
    }
    
}


