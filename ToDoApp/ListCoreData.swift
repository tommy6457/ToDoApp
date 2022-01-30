//
//  List.swift
//  ToDoApp
//
//  Created by 蔡尚諺 on 2022/1/26.
//

import Foundation
import UIKit
import CoreData

struct ListCoreData {
    
    let entityName = "ToDoData"
    
    static let shared = ListCoreData()
    
    //Read Core Data
    func fetchData() -> [ToDoData]? {
        
        var toDoData: [ToDoData]?
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            
            let context = appDelegate.persistentContainer.viewContext
            if let result = try? context.fetch(ToDoData.fetchRequest()) {
                toDoData = result
            }
            
        }
        
        return toDoData
    }
    
    //Insert Core Data
    func insertData(name: String , descript: String , date: Date) throws {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            
            let context = appDelegate.persistentContainer.viewContext
            
            let toDo = NSEntityDescription.insertNewObject(forEntityName: "\(ToDoData.self)", into: context) as! ToDoData
            
            toDo.name = name
            toDo.descript = descript
            toDo.date = date
            toDo.done = false
            
            do {
                
                if context.hasChanges {
                    try context.save()
                }
                
            } catch let error {
                throw error
                
            }
            
        }
        
    }
    
    // Update Core Data
    func updateData(todoData: ToDoData) throws {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            
            let context = appDelegate.persistentContainer.viewContext
            
            do {
                
                if context.hasChanges {
                    try context.save()
                }
                
            } catch let error {
                throw error
            }
            
        }
        
    }
    
    // Delete Core Data
    func deleteData(todoData: ToDoData) throws  {
                
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            
            let context = appDelegate.persistentContainer.viewContext
            
            context.delete(todoData)
            
            do {
                
                if context.hasChanges {
                    try context.save()
                }
                
            } catch let error {
                throw error
            }
            
        }
        
    }
    
    //日期轉字串
    func fomatingDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter.string(from: date)
    }
    
}

