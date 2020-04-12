//
//  TodoTableViewController.swift
//  ToDoList
//
//  Created by Alenazi F (FCES) on 14/03/2020.
//  Copyright © 2020 Alenazi F (FCES). All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController, UISearchBarDelegate {
    
    var todoArray:[TodoEntry]=[];
    var filteredTasks:[TodoEntry]=[];
    
    func sortByDate(dataArray:[TodoEntry])->[TodoEntry]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd, yyyy"
        
        let dueDates: [Date] = dataArray.map{dateFormatter.date(from: $0.dueDate)!}
        let dateTuples = zip(dataArray, dueDates)
        
        let sortedDataArray = dateTuples.sorted{$0.1 < $1.1} .map {$0.0}
        return sortedDataArray
    }
 

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedTasks = loadTask(){
            todoArray = savedTasks;
            todoArray = sortByDate(dataArray: todoArray)
            filteredTasks = todoArray;
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    //search bar action
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText: String){
        
        if searchText.isEmpty{
            todoArray = sortByDate(dataArray: todoArray)
            filteredTasks = todoArray;
        }else{
            filteredTasks = todoArray.filter({task-> Bool in
                guard let text = searchBar.text else {return false}
                return task.task.contains(text);
            });
        }
        tableView.reloadData();
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredTasks.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoTableViewCell else{
            fatalError("The dequeued cell is not an instace of a TodoTableViewCell")
        }

        // Configure the cell...
        let todo = filteredTasks[indexPath.row];
        cell.taskLabel.text = todo.task;
        cell.categoryLabel.text = todo.category;
        cell.dueDateLabel.text = todo.dueDate;
        cell.taskImage.image = todo.taskImage;
        
        
        

        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //get hold of the record to be deleted
            let deletedRecord = filteredTasks[indexPath.row];
            
            //delete from the filteredTasks collection
            filteredTasks.remove(at: indexPath.row)
            
            for i in indexPath.row ..< todoArray.count{
                if (todoArray[i].task == deletedRecord.task && todoArray[i].taskImage == deletedRecord.taskImage){
                    //update the contact in the original array
                    todoArray.remove(at: i);
                    break;
                }
            }
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            //save the tasks
            saveTask();
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "AddTodo":
            //everything is fine
            break;
        case "ViewTask":
            //load the task details for it to be displayed
            guard let taskViewController = segue.destination as? TodoViewController else{
                fatalError("unexpected destination");
            }
            guard let indexPath = tableView.indexPathForSelectedRow else{
                fatalError("The selected cell is not being displayed by the table");
            }
            let selectedTask = filteredTasks[indexPath.row];
            taskViewController.task = selectedTask;
            break;
        default:
            fatalError("Unexpected segue");
            break;
        }
        
    }
    
    
    @IBAction func unwindToTodos(sender:UIStoryboardSegue){
        //downcast to TodoViewController as this is who would have sent the action
        if let sourceViewController = sender.source as? TodoViewController, let task = sourceViewController.task{
            //check if this is an edit
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                
                let selectedRecord = filteredTasks[selectedIndexPath.row];
                //update the exisiting task
                filteredTasks[selectedIndexPath.row] = task;
                for i in selectedIndexPath.row ..< todoArray.count{
                    if (todoArray[i].task == selectedRecord.task && todoArray[i].taskImage == selectedRecord.taskImage){
                        //update the contact in the original array
                        todoArray[i] = task;
                        break;
                    }
                }
                //reloads from the filtered array
                filteredTasks = sortByDate(dataArray: filteredTasks)
                tableView.reloadData();
            }else{
                //add the new contact
                let newIndexPath = IndexPath(row: todoArray.count, section:0);
                //reset everything and add the new task
                searchBar.text = nil;
                
                todoArray.append(task);
                todoArray = sortByDate(dataArray: todoArray)
                filteredTasks = todoArray;
                tableView.reloadData();
            }
            saveTask();
            
        }
    }
    
    //private methods
    private func saveTask(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(todoArray, toFile: TodoEntry.ArchiveURL.path)
        if !isSuccessfulSave{
            print("Save unsuccessful");
        }
    }
    
    private func loadTask() -> [TodoEntry]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: TodoEntry.ArchiveURL.path) as? [TodoEntry];
    }

}
