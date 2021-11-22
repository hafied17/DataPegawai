//
//  AddFormController.swift
//  DataPegawai
//
//  Created by hafied Khalifatul ash.shiddiqi on 15/11/21.
//

import UIKit
import CoreData

class AddFormController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imageEmployee: UIImageView!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    var employeeID = 0
    let imagePiker = UIImagePickerController()
    
    // deklarasi core data dari appdelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Form Employees"
        setupView()
    }
    
    func setupView() {
        imagePiker.delegate = self
        imagePiker.allowsEditing = true
        imagePiker.sourceType = .photoLibrary
        
        //di execute saat id ada
        if employeeID != 0 {
            let employeeFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
            employeeFetch.fetchLimit = 1
            // kondisi dengan predicate
            employeeFetch.predicate = NSPredicate(format: "id == \(employeeID)")
            
            //run
            let result = try! context.fetch(employeeFetch)
            let employee: Employees = result.first as! Employees
            firstNameTextField.text = employee.firstName
            lastNameTextField.text = employee.lastName
            emailTextField.text = employee.email

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY"
            let date = dateFormatter.date(from: employee.birthDate!)
            datePicker.date = date!
            imageEmployee.image = UIImage(data: employee.image!)
            
        }
    }
    
    @IBAction func actionSave(_ sender: Any) {
        guard let firstName = firstNameTextField.text, firstName != "" else {
            let alertController = UIAlertController(title: "Error" , message: "First name is Require", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let lastName = lastNameTextField.text, lastName != "" else {
            let alertController = UIAlertController(title: "Error" , message: "Last name is Require", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let email = emailTextField.text, email != "" else {
            let alertController = UIAlertController(title: "Error" , message: "first name is Require", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let birtDate = dateFormatter.string(from: datePicker.date)
        
        if employeeID > 0 {
            let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees")
            employeesFetch.fetchLimit = 1
            employeesFetch.predicate = NSPredicate(format: "id == \(employeeID)")
            
            let result = try! context.fetch(employeesFetch)
            let employees: Employees = result.first as! Employees
            
            employees.firstName = firstName
            employees.lastName = lastName
            employees.email = email
            
            let dataFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY"
            let date = dateFormatter.string(from: datePicker.date)
            employees.birthDate = date
            
            if let img = imageEmployee.image {
                let data = img.pngData() as NSData?
                employees.image = data as Data?
                
            }
            //save
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        
        } else {
            //add ke employee
            let employees = Employees(context: context)
            
            let request: NSFetchRequest = Employees.fetchRequest()
            let sortDescriptors = NSSortDescriptor(key: "id", ascending: false)
            request.sortDescriptors = [sortDescriptors]
            request.fetchLimit = 1
            
            var maxID = 0
            do {
                let lastEmployees = try context.fetch(request)
                maxID = Int(lastEmployees.first?.id ?? 0)
            } catch {
                print(error.localizedDescription)
            }
            employees.id = Int32(maxID) + 1
            employees.firstName = firstName
            employees.lastName = lastName
            employees.email = email
            employees.birthDate = birtDate
            
            if let img = imageEmployee.image {
                let data = img.pngData() as NSData?
                employees.image = data as Data?
            }
            // save core data
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionTakePicture(_ sender: Any) {
        self.selectPhotoFromLibrary()
    }
    func selectPhotoFromLibrary() {
        self.present(imagePiker, animated: true, completion: nil)
    }


}

extension AddFormController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageEmployee.contentMode = .scaleToFill
            self.imageEmployee.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
