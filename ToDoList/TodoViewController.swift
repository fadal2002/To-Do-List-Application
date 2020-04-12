//
//  ViewController.swift
//  ToDoList
//
//  Created by Alenazi F (FCES) on 13/03/2020.
//  Copyright © 2020 Alenazi F (FCES). All rights reserved.
//

import UIKit

class TodoViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var categoryTitle: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var taskImage: UIImageView!
    
    var task:TodoEntry?;
    
    
    @IBAction func selectImageForTask(_ sender: UITapGestureRecognizer) {
        if taskImage.image == UIImage(named:"emptyCheckBox"){
            taskImage.image = UIImage(named:"checkMarkImg")
        }else{
            taskImage.image = UIImage(named:"emptyCheckBox")
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        if isPresentingInAddTaskMode{
            dismiss(animated: true, completion: nil);
        }else{
            if let owningNavigationController = navigationController{
                owningNavigationController.popViewController(animated: true);
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.taskTitle.delegate = self;
        self.categoryTitle.delegate = self;
        taskTitle.resignFirstResponder();
        
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let viewingTask = task{
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM dd, yyyy"
            let dateObj = dateFormatter.date(from: viewingTask.dueDate);
            taskTitle.text = viewingTask.task;
            categoryTitle.text = viewingTask.category;
            taskImage.image = viewingTask.taskImage;
            dueDatePicker.date = dateObj!;
            
        }
    }
    //functions to hide and show the keyboard correctly
    deinit {
        //stop listening for keyboard events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTitle.resignFirstResponder()
        categoryTitle.resignFirstResponder()
        return true;
    }
    
    @objc func keyboardWillChange(notification: Notification){

        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            
            view.frame.origin.y = -keyboardRect.height
        }else{
            view.frame.origin.y = 0
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        super.prepare(for: segue, sender: sender);
        
        //we need to check if the save button was pressed or if it was the cancel button
        guard let button = sender as? UIBarButtonItem, button===saveButton else{
            return;
        }
        
        
        //save the contact
        //using the date formatter to format the due date of the task correctly
        let formatter = DateFormatter()
        formatter.calendar = dueDatePicker.calendar
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: dueDatePicker.date)
        
        let todoTitle = taskTitle.text ?? "";
        let todoCategory = categoryTitle.text ?? "";
        let todoDueDate = dateString;
        let todoImage = taskImage.image;
        
        
        task = TodoEntry(task: todoTitle, category: todoCategory, dueDate: todoDueDate, taskImage: todoImage);
    }
    
}



