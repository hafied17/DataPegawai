//
//  ViewController.swift
//  DataPegawai
//
//  Created by hafied Khalifatul ash.shiddiqi on 15/11/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UISearchControllerDelegate {
    
    var employees:[Employees] = []
    var filteredEmployees: [Employees] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    // deklarasi core data dari appdelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableEmployee: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        print("hello")
    }
    override func viewWillAppear(_ animated: Bool) {
        do {
            let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
            employees = try context.fetch(employeesFetch) as! [Employees]
        }catch {
            print(error.localizedDescription)
        }
        self.tableEmployee.reloadData()
    }

    func setupView() {
        tableEmployee.delegate = self
        tableEmployee.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Find Employee"
//        searchController.hidesNavigationBarDuringPresentation = true
        
        tableEmployee.tableHeaderView = searchController.searchBar
        
        self.navigationItem.title = "Employees"
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.14, green: 0.86, blue: 0.73, alpha: 1.0)
//        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.14, green: 0.86, blue: 0.73, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && !((searchController.searchBar.text?.isEmpty)!){
            return filteredEmployees.count
        }
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var employee = employees[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        if searchController.isActive && !((searchController.searchBar.text?.isEmpty)!) {
            employee = filteredEmployees[indexPath.row]
        } else {
            employee = employees[indexPath.row]
        }
        
        cell.titleCell.text = employee.firstName
        cell.subtitleCell.text = employee.lastName
        if let imageData = employee.image {
            cell.imageCell.image = UIImage(data: imageData as Data)
            cell.imageCell.layer.cornerRadius = cell.imageCell.frame.height / 2
            cell.imageCell.clipsToBounds = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(identifier: "detailController") as! DetailViewController
        controller.employeeID = Int(employees[indexPath.row].id)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let keyword = searchController.searchBar.text!
        if keyword.count > 0 {
            print("kata kunci \(keyword)")
            let employeeSearch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
 
            let predicate1 = NSPredicate(format: "firstName CONTAINS[c] %@", keyword)
            let predicate2 = NSPredicate(format: "lastName CONTAINS[c] %@", keyword)
            
            let predicateCompound = NSCompoundPredicate.init(type: .or, subpredicates: [predicate1,predicate2])
            employeeSearch.predicate = predicateCompound
            
            //run Query
            do {
                let employeesFilters = try context.fetch(employeeSearch) as! [NSManagedObject]
                filteredEmployees = employeesFilters as! [Employees]
            }catch{
                print(error)
            }
            self.tableEmployee.reloadData()
        }
        
    }

}
