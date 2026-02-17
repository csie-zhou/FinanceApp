////import CloudKit
//// PersistenceController.swift
//import CoreData
//
//class PersistenceController {
//  static let shared = PersistenceController()
//
//  let container: NSPersistentCloudKitContainer
//
//  init() {
//    container = NSPersistentCloudKitContainer(name: "FinanceApp")
//
//    // Enable CloudKit sync
//    guard let description = container.persistentStoreDescriptions.first else {
//      fatalError("No store description found")
//    }
//
//    // Configure CloudKit
//    description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
//      containerIdentifier: "iCloud.com.yourname.financeapp"
//    )
//
//    // Enable history tracking for sync
//    description.setOption(
//      true as NSNumber,
//      forKey: NSPersistentHistoryTrackingKey)
//    description.setOption(
//      true as NSNumber,
//      forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
//
//    container.loadPersistentStores { storeDescription, error in
//      if let error = error {
//        fatalError("Core Data failed to load: \(error)")
//      }
//    }
//
//    // Automatically merge changes from CloudKit
//    container.viewContext.automaticallyMergesChangesFromParent = true
//    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//  }
//
//  func save() {
//    let context = container.viewContext
//
//    if context.hasChanges {
//      do {
//        try context.save()
//        // CloudKit will automatically sync this change
//      } catch {
//        print("Failed to save: \(error)")
//      }
//    }
//  }
//}
// PersistenceController.swift
import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FinanceApp")
        
        if inMemory {
            // Use temporary in-memory store for tests
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
