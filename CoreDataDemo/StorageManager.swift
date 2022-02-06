//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Ульяна Гритчина on 05.02.2022.
//

import UIKit
import CoreData

class StorageManager {
    
    static let shered = StorageManager()
    
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchData(complition: (Result <[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try context.fetch(fetchRequest)
            complition(.success(taskList))
        } catch let error {
            complition(.failure(error))
        }
    }
    
    func save(taskName: String, complition: (Task) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        
        task.title = taskName
        complition(task)
        
        saveContext()
    }
    
    func delete(task: Task) {
        context.delete(task)
        saveContext()
    }
    
    func edit(task: Task, newTask: String) {
        task.title = newTask
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
}
