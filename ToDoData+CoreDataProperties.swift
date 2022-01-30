//
//  ToDoData+CoreDataProperties.swift
//  ToDoApp
//
//  Created by 蔡尚諺 on 2022/1/27.
//
//

import Foundation
import CoreData


extension ToDoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoData> {
        return NSFetchRequest<ToDoData>(entityName: "ToDoData")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var descript: String?
    @NSManaged public var done: Bool

}

extension ToDoData : Identifiable {

}
