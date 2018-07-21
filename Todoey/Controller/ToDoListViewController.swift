//
//  ViewController.swift
//  Todoey
//
//  Created by Tibi on 19/07/2018.
//  Copyright © 2018 Tiberiu Gradinariu. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [TaskModel] ()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: table view delegate/data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TaskTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "taskCellIdentifier") as! TaskTableViewCell?)!
        let model = itemArray[indexPath.row]
        cell.model = model
        cell.textLabel?.text = cell.model!.name
        cell.accessoryType = cell.model!.isCompleted ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell : TaskTableViewCell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
        if let model = cell.model {
            model.isCompleted = !model.isCompleted
            cell.accessoryType = model.isCompleted ? .checkmark : .none
        }
        saveItems()
    }
    
    // MARK: - Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController.init(title: "Add new todoey item", message: "", preferredStyle: .alert)
        var alertTextfield = UITextField()
        alert.addTextField { (textfield) in
            textfield.placeholder = "Add title of new todoey";
            alertTextfield = textfield
        }
        let action = UIAlertAction.init(title: "Add item", style: .default) { (action) in
            if alertTextfield.text != "" {
                let newItem = TaskModel(context: self.context)
                newItem.name = alertTextfield.text!
                newItem.isCompleted = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                self.saveItems()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: load/save
    
    func loadItems(with request: NSFetchRequest<TaskModel> = TaskModel.fetchRequest(), predicate : NSPredicate? = nil) {
        var predicates : [NSPredicate] = [NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)]
        if let existingPredicate = predicate {
            predicates.append(existingPredicate)
        }
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        print("tasks loaded \(itemArray.count)")
        tableView.reloadData()
    }
    
    func saveItems() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
}

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
        request.predicate = NSPredicate.init(format: "name CONTAINS %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.loadItems(with: request, predicate: request.predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

