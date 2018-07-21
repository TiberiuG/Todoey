//
//  CategoriesTableViewController.swift
//  Todoey
//
//  Created by Tibi on 20/07/2018.
//  Copyright © 2018 Tiberiu Gradinariu. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {

    var categories = [Category]()
    var selectedCategory : Category?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.loadCategories()
    }
    
    // MARK: Tableview data source & delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCellIdentifier")
        let category = categories[indexPath.row]
        cell?.textLabel?.text = category.name
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        
        performSegue(withIdentifier: "goToTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        destinationVC.selectedCategory = selectedCategory
    }
    
    // MARK: load/save categories
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print ("error loading categories \(error)")
        }
        tableView.reloadData();
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: IBActions
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        var alertTextField = UITextField()
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter category name"
            alertTextField = textfield
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = alertTextField.text!
            self.categories.append(newCategory)
            self.saveCategories()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension CategoriesTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadCategories(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadCategories()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
