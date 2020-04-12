//
//  TodoEntry.swift
//  ToDoList
//
//  Created by Alenazi F (FCES) on 13/03/2020.
//  Copyright © 2020 Alenazi F (FCES). All rights reserved.
//

import UIKit

class TodoEntry:NSObject, NSCoding{
    func encode(with coder: NSCoder) {
        coder.encode(task, forKey: PropertyKey.task);
        coder.encode(category, forKey: PropertyKey.category);
        coder.encode(dueDate, forKey: PropertyKey.dueDate);
        coder.encode(taskImage, forKey: PropertyKey.taskImage);
    }
    
    required convenience init?(coder: NSCoder) {
        //make sure we can decode the task, otherwise the intialiser should fail
        guard let task = coder.decodeObject(forKey: PropertyKey.task)as? String else{
            print("unable to decode the todo entry");
            return nil;
        }
        
        guard let category = coder.decodeObject(forKey: PropertyKey.category)as? String else{
            print("unable to decode the todo entry");
            return nil;
        }
        
        guard let dueDate = coder.decodeObject(forKey: PropertyKey.dueDate)as? String else{
            print("unable to decode the todo entry");
            return nil;
        }
        
        let taskImage = coder.decodeObject(forKey: PropertyKey.taskImage)as? UIImage;
        
        self.init(task:task, category:category, dueDate:dueDate, taskImage:taskImage);
    }
    
    var task: String
    var category: String
    var dueDate: String
    var taskImage: UIImage?
    
    init?(task:String, category:String, dueDate:String, taskImage:UIImage?) {
        //check for a valid task, category, and dueDate
        if(task.isEmpty || category.isEmpty || dueDate.isEmpty){
            return nil;
        }
        
        self.task = task;
        self.category = category;
        self.dueDate = dueDate;
        self.taskImage = taskImage;
    }
    
    //make data saveable
    struct PropertyKey {
        static let task = "task";
        static let category = "category";
        static let dueDate = "dueDate";
        static let taskImage = "taskImage";
    }
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("TodoEntries");
    
    
    
}
