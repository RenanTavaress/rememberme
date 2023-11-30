//
//  SchedulerModalViewController.swift
//  rememberme
//
//  Created by Renan Tavares on 25/07/23.
//

import UIKit
import CoreData
import EventKit
import EventKitUI

class SchedulerModalViewController: UIViewController {
    var store = EKEventStore()
    
    lazy var buttonSave: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Salvar", style: .done, target: self, action: #selector(pressed))
        return button
    }()
    
    lazy  var scheduleName: UITextField = {
        let name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.backgroundColor = .tertiarySystemGroupedBackground
        name.placeholder = "Digite o nome do compromisso"
        name.layer.cornerRadius = 10
        name.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: name.frame.width))
        name.leftViewMode = .always
        let heightConstraint = name.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
        name.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return name
    }()
    
    lazy var dateFieldValue: UITextField = {
        let fieldValue = UITextField()
        fieldValue.backgroundColor = .tertiarySystemGroupedBackground
        fieldValue.translatesAutoresizingMaskIntoConstraints = false
        fieldValue .leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: fieldValue.frame.width))
        fieldValue.leftViewMode = .always
        fieldValue.textAlignment = .left
        fieldValue.placeholder = "Data: "
        fieldValue.layer.cornerRadius = 10
        let heightConstraint = fieldValue.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
        return fieldValue
    }()
    
    lazy var dateSchedule: UIDatePicker = {
        let dateSchdule = UIDatePicker()
        dateSchdule.locale = .current
        dateSchdule.datePickerMode = .dateAndTime
        dateSchdule.timeZone = TimeZone.current
        dateSchdule.minimumDate = .now
        dateSchdule.translatesAutoresizingMaskIntoConstraints = false
        dateSchdule.preferredDatePickerStyle = .compact
        return dateSchdule
    }()
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange() {
        if  let name = scheduleName.text, !name.isEmpty {
            buttonSave.isEnabled = true
        } else {
            buttonSave.isEnabled = false
        }
    }
    
    @objc func pressed(){
        let getContext =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let schedule = ScheduleCoreData(context: getContext)
        guard let calendar = store.defaultCalendarForNewEvents else { return }
        let newEvent = EKEvent(eventStore: store)
        guard let scheduleName = scheduleName.text else { return }
        schedule.name =  scheduleName
        schedule.date = dateSchedule.date
        schedule.id = UUID()
        do {
            if  !scheduleName.isEmpty {
                try getContext.save()
                newEvent.title = scheduleName
                newEvent.startDate = dateSchedule.date
                newEvent.endDate = newEvent.startDate
                newEvent.calendar = calendar
                try store.save(newEvent, span: .thisEvent, commit: true)
                NotificationCenter.default.post(name: Notification.Name("Saved"), object: schedule)
                self.dismiss(animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Falta o titulo do compromisso", message: "Por favor, coloque o titulo do compromisso", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
        } catch {
            print("Erro ao salvar objeto: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = buttonSave
        
        navigationItem.title = "Informações necessárias"
        
        view.addSubview(scheduleName)
        view.addSubview(dateFieldValue)
        dateFieldValue.addSubview(dateSchedule)
        
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            scheduleName.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            scheduleName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            scheduleName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            dateFieldValue.topAnchor.constraint(equalTo: scheduleName.topAnchor, constant: 70),
            dateFieldValue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            dateFieldValue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            dateSchedule.trailingAnchor.constraint(equalTo: dateFieldValue.trailingAnchor , constant: -15),
            dateSchedule.centerXAnchor.constraint(equalTo: dateFieldValue.centerXAnchor),
            dateSchedule.centerYAnchor.constraint(equalTo: dateFieldValue.centerYAnchor)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presentationController?.containerView?.backgroundColor = .systemGroupedBackground
    }
}


extension SchedulerModalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
