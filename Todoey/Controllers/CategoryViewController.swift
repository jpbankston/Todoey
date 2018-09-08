//
//  CategoryViewController.swift
//  Todoey
//
//  Created by James Bankston on 9/4/18.
//  Copyright © 2018 James Bankston. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var defaultNavBarColor: UIColor?
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        defaultNavBarColor = navigationController?.navigationBar.barTintColor

        loadCategories()
        
        tableView.separatorStyle = .none
    }


    //MARK: NavBar setup methods
    override func viewWillAppear(_ animated: Bool) {
        //MARK: - Add code to count items in Category and place number in label itemCount
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exists")}
        navBar.barTintColor = defaultNavBarColor
        navBar.tintColor = ContrastColorOf(defaultNavBarColor!, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(defaultNavBarColor!, returnFlat: true)]
        loadCategories()
  }


    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = String(category.name + " (\(category.items.count) Items)")

            guard let categoryColor = UIColor(hexString: category.hexColor ?? "#1D4711" ) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }


    //MARK: - Ad New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen once the user clicks the "Add Category" button on the UIAlert

            if textField.text != "" {
                let newCategory = Category()
                newCategory.hexColor = UIColor.randomFlat.hexValue()
                newCategory.name = textField.text!
                
                self.save(category: newCategory)
            }
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create new Category"
        }
        
        present(alert, animated: true, completion: nil)
    }


    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        
        do {
            try realm.write {
            realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
        tableView.reloadData()
    }

    
    //MARK: - Delete data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]
        {
            do {
                try self.realm.write {
                    let todoItems = categoryForDeletion.items
                    
                    // delete associated items (if any)
                    if todoItems.count > 0 {
                        realm.delete(todoItems)
                    }
                    self.realm.delete(categoryForDeletion)
               }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }

    
    func loadCategories(){
        categories = realm.objects(Category.self)

        tableView.reloadData()
        
    }
    
}
