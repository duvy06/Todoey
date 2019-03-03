//
//  ViewController.swift
//  Todoey
//
//  Created by Yvon Duvivier on 25/02/2019.
//  Copyright © 2019 Yvon Duvivier. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()

    // set as global to declare a new plist insteed using userDefault one
    // this will declare where my plist will be stored
    let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items2.plist")
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(datafilePath!)

        // this print return :
        // file:///Users/duvy/Library/Developer/CoreSimulator/Devices/E50D6F0B-4236-4CCB-8128-C70E30EB67A5/data/Containers/Data/Application/588FBA8A-E746-4B6C-9E92-3AC8C2B933EF/Documents/
        // then go to Preferences to see DuvyOrg.Todoey.plist
        
        // not anymore used because it is now loaded from our plist
//        let newItem = Item()
//        newItem.title = "Buy milk"
//        itemArray.append(newItem)
//        let newItem2 = Item()
//        newItem2.title = "Find chocolate"
//        itemArray.append(newItem2)
//        let newItem3 = Item()
//        newItem3.title = "Buy eggs"
//        itemArray.append(newItem3)

//        // reload itemArray from userDefaults
//        if let items = defaults.array(forKey: "TodoItemArray") as? [Item] {
//            itemArray = items
//        }
        // use now my own plist
        loadItems()
    }

    //MARK- TableView datasource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        // replace long value in a shorter one
        let itemRow = itemArray[indexPath.row]
        // replace those if instructions with a ternary operation
//        if itemRow.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
          // checking true can be supressed
          //cell.accessoryType = itemRow.done == true ? .checkmark : .none
          cell.accessoryType = itemRow.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK- TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //print (itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
    }
    
    // add button pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            print (textField)
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
            
//          self.defaults.set(self.itemArray, forKey: "TodoItemArray")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Place the new one"
            // alertTextField only exist in this closure and
            // should be saved in a local variable in order to use it in this method see action
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }

    //MARK- Model Manipulation Method
    
    func saveItems() {
        // use now encoder to use my own plist that will accept custom variable like a dictionary
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: datafilePath!)
        } catch {
            print("Error encoding itemArray, \(error)")
        }
        self.tableView.reloadData()

    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: datafilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding itemAray, \(error)")
            }
        }

    }
}

