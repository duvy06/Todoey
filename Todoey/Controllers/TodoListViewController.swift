//
//  ViewController.swift
//  Todoey
//
//  Created by Yvon Duvivier on 25/02/2019.
//  Copyright © 2019 Yvon Duvivier. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()

    // set as global to declare a new plist insteed using userDefault one
    // this will declare where my plist will be stored
    //let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items2.plist")
    //let defaults = UserDefaults.standard
    // used by CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // used to locate where CoreDate SQLITE is located
        // let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //print(datafilePath)
//        sourceURL = "file:///Users/duvy/Library/Developer/CoreSimulator/Devices/E50D6F0B-4236-4CCB-8128-C70E30EB67A5/data/Containers/Data/Application/50976AF2-B0AA-4FD8-892A-062917537843/Library/Application%20Support/DataModel.sqlite";

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
        // due to mod in loadItems where we provide a default value Item.fetchRequest()
        // it is not necessary to give an argument here
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        // this request is in fact empty and will return all items
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
        // ok to flag
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // now try to delete the item (row) only a test but it is working well!!
//        context.delete(itemArray[indexPath.row])
//        // delete first the context before itemArray otherwise row value will be invalid to delete in the context
//        itemArray.remove(at: indexPath.row)

        saveItems()
        
    }
    
    // add button pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //print (textField)
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
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
//        let encoder = PropertyListEncoder()
//        
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: datafilePath!)
//        } catch {
//            print("Error encoding itemArray, \(error)")
//        }
        
        // with CoreData
        // we now commit all changes made in context (temporary area)

        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()

    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
//        // used with NSCoder and own plist
//        if let data = try? Data(contentsOf: datafilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//            itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding itemAray, \(error)")
//            }
//        }

        // used with CoreData
        // not needed let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray =  try context.fetch(request)
        } catch {
            print("Context is not available,\(error)")
        }
        tableView.reloadData()

    }
}

// insteed to add delegate in the main viewcontroller, add an extension here
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //print(searchBar.text)
        // [cd] means c is NOT case sensitive and d not diacritic (accent)
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request)
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
