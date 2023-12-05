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
    
    lazy var startDateFieldValue: UITextField = {
        let fieldValue = UITextField()
        fieldValue.backgroundColor = .tertiarySystemGroupedBackground
        fieldValue.translatesAutoresizingMaskIntoConstraints = false
        fieldValue .leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: fieldValue.frame.width))
        fieldValue.leftViewMode = .always
        fieldValue.textAlignment = .left
        fieldValue.placeholder = "Data Início: "
        fieldValue.layer.cornerRadius = 10
        let heightConstraint = fieldValue.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
        return fieldValue
    }()
    
    lazy var endDateFieldValue: UITextField = {
        let endFieldValue = UITextField()
        endFieldValue.backgroundColor = .tertiarySystemGroupedBackground
        endFieldValue.translatesAutoresizingMaskIntoConstraints = false
        endFieldValue .leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: endFieldValue.frame.width))
        endFieldValue.leftViewMode = .always
        endFieldValue.textAlignment = .left
        endFieldValue.placeholder = "Data Final: "
        endFieldValue.layer.cornerRadius = 10
        let heightConstraint = endFieldValue.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
        return endFieldValue
    }()
    
    lazy var startDateSchedule: UIDatePicker = {
        let dateSchdule = UIDatePicker()
        dateSchdule.locale = .current
        dateSchdule.datePickerMode = .dateAndTime
        dateSchdule.timeZone = TimeZone.current
        dateSchdule.minimumDate = .now
        dateSchdule.translatesAutoresizingMaskIntoConstraints = false
        dateSchdule.preferredDatePickerStyle = .compact
        return dateSchdule
    }()
    
    
    lazy var endDateSchedule: UIDatePicker = {
        let endDateSchdule = UIDatePicker()
        endDateSchdule.locale = .current
        endDateSchdule.datePickerMode = .dateAndTime
        endDateSchdule.timeZone = TimeZone.current
        endDateSchdule.minimumDate = .now
        endDateSchdule.translatesAutoresizingMaskIntoConstraints = false
        endDateSchdule.preferredDatePickerStyle = .compact
        return endDateSchdule
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
        schedule.startDate = startDateSchedule.date
        schedule.endDate = endDateSchedule.date
        schedule.id = UUID()
        do {
            if  !scheduleName.isEmpty {
                try getContext.save()
                newEvent.title = scheduleName
                newEvent.startDate = startDateSchedule.date
                newEvent.endDate = endDateSchedule.date
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
        view.addSubview(startDateFieldValue)
        view.addSubview(endDateFieldValue)
        startDateFieldValue.addSubview(startDateSchedule)
        endDateFieldValue.addSubview(endDateSchedule)
        
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            scheduleName.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            scheduleName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            scheduleName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            startDateFieldValue.topAnchor.constraint(equalTo: scheduleName.topAnchor, constant: 70),
            startDateFieldValue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            startDateFieldValue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            startDateSchedule.trailingAnchor.constraint(equalTo: startDateFieldValue.trailingAnchor, constant: -15),
            startDateSchedule.centerXAnchor.constraint(equalTo: startDateFieldValue.centerXAnchor),
            startDateSchedule.centerYAnchor.constraint(equalTo: startDateFieldValue.centerYAnchor),
            
            endDateFieldValue.topAnchor.constraint(equalTo: startDateFieldValue.topAnchor, constant: 60),
            endDateFieldValue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            endDateFieldValue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            endDateSchedule.trailingAnchor.constraint(equalTo: endDateFieldValue.trailingAnchor, constant: -15),
            endDateSchedule.centerXAnchor.constraint(equalTo: endDateFieldValue.centerXAnchor),
            endDateSchedule.centerYAnchor.constraint(equalTo: endDateFieldValue.centerYAnchor),
            
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
