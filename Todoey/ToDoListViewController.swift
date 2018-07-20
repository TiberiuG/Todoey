//
//  ViewController.swift
//  Todoey
//
//  Created by Tibi on 19/07/2018.
//  Copyright © 2018 Tiberiu Gradinariu. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Learn Core Data", "Implement Game Browser screen", "Fix start index bugs"];
    let userDefaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = userDefaults.array(forKey: "todos") as? [String] {
            itemArray = items;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "taskCellIdentifier")!;
        cell.textLabel?.text = itemArray[indexPath.row];
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell selected at row \(indexPath.row)");
        tableView.deselectRow(at: indexPath, animated: true);
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark;
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK - Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController.init(title: "Add new todoey item", message: "", preferredStyle: .alert);
        var alertTextfield = UITextField();
        alert.addTextField { (textfield) in
            textfield.placeholder = "Add title of new todoey";
            alertTextfield = textfield;
        }
        let action = UIAlertAction.init(title: "Add item", style: .default) { (action) in
            if alertTextfield.text != "" {
                self.itemArray.append(alertTextfield.text!);
                self.userDefaults.setValue(self.itemArray, forKey: "todos");
                self.tableView.reloadData();
            }
        }
        alert.addAction(action);
        present(alert, animated: true, completion: nil);
    }
}

