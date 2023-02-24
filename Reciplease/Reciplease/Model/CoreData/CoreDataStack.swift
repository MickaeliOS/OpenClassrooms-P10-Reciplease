//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Mickaël Horn on 02/02/2023.
//

import Foundation
import CoreData

class CoreDataStack {
    // MARK: - Singleton
    static let sharedInstance = CoreDataStack()
    private init() {}
    
    // MARK: - Properties
    private let persistentContainerName = "Reciplease"
    
    // MARK: - Public
    var viewContext: NSManagedObjectContext {
        return CoreDataStack.sharedInstance.persistentContainer.viewContext
    }

    // MARK: - Private
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo) for: \(storeDescription.description)")
            }
        }
        
        return container
    }()
}

