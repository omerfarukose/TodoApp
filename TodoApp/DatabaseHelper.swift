//
//  DatabaseHelper.swift
//  TodoApp
//
//  Created by Ömer Faruk KÖSE on 20.10.2021.
//

import Foundation
import CoreData
import UIKit

class DataBaseHelper{
    
    static let shareInstance = DataBaseHelper()
    
    func fetch() -> [TaskEntity] {
        var taskArray = [TaskEntity]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        do{
            taskArray = try context.fetch(fetchRequest) as! [TaskEntity]
        }catch{
            print(error)
        }
        
        return taskArray
    }
    
    
    
    func save(name: String , isdone: Bool){
        // guard let appDelegate = UIApplication.shared.delegate as! AppDelegate {return}
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let instance = TaskEntity(context: context)
        
        instance.name = name
        instance.isdone = isdone
        
        do{
            try context.save()
            print("Succes...")
        }catch let Error as NSError{
            print("Error : \(Error) , \(Error.localizedDescription)")
        }
        
    }
    
    func delete(name: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do{
            let response = try context.fetch(fetchRequest)
            
            let objectToDelete = response[0] as! NSManagedObject
            context.delete(objectToDelete)
            
            do{
                try context.save()
                print("Succes...")
            }catch{
                print(error)
            }
        }catch{
            print(error)
        }
        
    }
    
    func update(name: String , isdone: Bool){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        do{
            let tasks = try context.fetch(fetchRequest) as! [TaskEntity]
            tasks.first?.isdone = isdone
            tasks[0].name = name // same thing
            try context.save()
            
        }catch{
            print(error)
        }
    }
    
}

