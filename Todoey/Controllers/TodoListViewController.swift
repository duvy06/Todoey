//
//  ViewController.swift
//  Todoey
//
//  Created by Yvon Duvivier on 25/02/2019.
//  Copyright © 2019 Yvon Duvivier. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    
    var realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK- TableView datasource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = todoItems?[indexPath.row].title
        
        if let itemRow = todoItems?[indexPath.row] {
            cell.accessoryType = (itemRow.done) ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No item found"
        }
        return cell
    }
    
    //MARK- TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    // in case delete is needed insteed of updating
                    //realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error to save status, \(error)")
            }
        }
        tableView.reloadData()
    }
    
    // add button pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
        if let currentCategory = self.selectedCategory {
            do {
                try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.createdDate = Date()
                currentCategory.catItems.append(newItem)
                }
            } catch{
                print("Error saving new task, \(error)")
            }
        }
        self.tableView.reloadData()
    }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Place a new one"

            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }

    //MARK- Model Manipulation Method
    
    func loadItems() {
        
        todoItems = selectedCategory?.catItems.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
}

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
        tableView.reloadData()
    }
// doesn't work !!!
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        print("Cancel search")
//        loadItems()
//    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
