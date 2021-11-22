//
//  DetailViewController.swift
//  DataPegawai
//
//  Created by hafied Khalifatul ash.shiddiqi on 22/11/21.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelBirthdate: UILabel!
    
    var employeeID = 0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        let editButton = UIBarButtonItem(image: UIImage(named: "pencil"), style: .plain, target: self, action: #selector(edit))
        let deleteButton = UIBarButtonItem(image: UIImage(named: "trash"), style: .plain, target: self, action: #selector(deleteAction))
//        self.navigationItem.leftBarButtonItems = [editButton,deleteButton]
        self.navigationItem.rightBarButtonItems = [deleteButton, editButton]
    }
    @objc func edit(){
        let controller = self.storyboard?.instantiateViewController(identifier: "addFormController") as! AddFormController
        controller.employeeID = employeeID
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func deleteAction() {
        let alertController = UIAlertController(title: "Warning", message: "Are you sure to delete this one?", preferredStyle: .actionSheet)
        let alertActionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
            let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
            employeesFetch.fetchLimit = 1
            // kondisi dengan predicate
            employeesFetch.predicate = NSPredicate(format: "id == \(self.employeeID)")
            
            //run
            let result = try! self.context.fetch(employeesFetch)
            let employeeToDelete = result.first as! NSManagedObject
            self.context.delete(employeeToDelete)
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            self.navigationController?.popViewController(animated: true)
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(alertActionYes)
        alertController.addAction(alertActionCancel)
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        let employeeFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
        employeeFetch.fetchLimit = 1
        // kondisi dengan predicate
        employeeFetch.predicate = NSPredicate(format: "id == \(employeeID)")
        
        //run
        let result = try! context.fetch(employeeFetch)
        let employee: Employees = result.first as! Employees
        labelFirstName.text = employee.firstName
        labelLastName.text = employee.lastName
        labelEmail.text = employee.email
        labelBirthdate.text = employee.birthDate

        if let imageData = employee.image{
            imageView.image = UIImage(data: imageData as Data)
            imageView.layer.cornerRadius = imageView.frame.height / 2
            imageView.clipsToBounds = true
        }
        self.navigationItem.title = "\(employee.firstName!) \(employee.lastName!)"
    }
}
