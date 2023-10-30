//
//  SchedulerModalViewController.swift
//  rememberme
//
//  Created by Renan Tavares on 25/07/23.
//

import UIKit
import CoreData

class SchedulerModalViewController: UIViewController, UITableViewDelegate {
    lazy var labelTeste: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy  var scheduleName: UITextField = {
        let name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.backgroundColor = .systemBackground
        name.placeholder = "Digite o nome do compromisso"
        name.layer.cornerRadius = 10
        name.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: name.frame.width))
        name.leftViewMode = .always
        
        let heightConstraint = name.heightAnchor.constraint(equalToConstant: 45)
        heightConstraint.isActive = true
        
        // print(name)
        return name
    }()
    
    lazy var getDateSchedule: UIDatePicker = {
        let dateSchdule = UIDatePicker(frame: .zero)
        dateSchdule.locale = Locale(identifier: "pt_BR")
        dateSchdule.datePickerMode = .dateAndTime
        dateSchdule.timeZone = TimeZone.current
        dateSchdule.translatesAutoresizingMaskIntoConstraints = false
        //dateSchdule.preferredDatePickerStyle = .wheels
        //print(dateSchdule.date)
        
        return dateSchdule
        
    }()
    
    lazy var inputFieldValue: UITextField = {
        let fieldValue = UITextField()
        fieldValue.backgroundColor = .systemBackground
        fieldValue.translatesAutoresizingMaskIntoConstraints = false
        fieldValue.textAlignment = .center
        fieldValue.attributedPlaceholder = NSAttributedString(string: "Selecione a data", attributes: [NSAttributedString.Key.foregroundColor : UIColor.tintColor])
        fieldValue.layer.cornerRadius = 10
        
        let heightConstraint = fieldValue.heightAnchor.constraint(equalToConstant: 45)
        heightConstraint.isActive = true
        
        let doneBt = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        self.setToolbarItems([doneBt], animated: true)
        return fieldValue
    }()
    
    lazy var buttonDone: UIButton = {
        let buttonDone = UIButton()
        buttonDone.setTitle("Adicionar", for: .normal)
        buttonDone.backgroundColor = .systemBackground
        buttonDone.translatesAutoresizingMaskIntoConstraints = false
        buttonDone.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        buttonDone.setTitleColor(.tintColor, for: .normal)
        buttonDone.layer.cornerRadius = 10
        return buttonDone
    }()
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        return inputFieldValue.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func pressed(sender: UIButton){
        let getContext =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
        let schedule = ScheduleCoreData(context: getContext)
        
   
        if let name = scheduleName.text {
            schedule.scheduleName = name
        }
        
        schedule.dateSchedule = getDateSchedule.date
        schedule.id = UUID()
        //print(scheduleName)
        //print(schedule.dateSchedule!)
        
        
        do {
            try getContext.save()
            print("salvouuuuuu")
            
            
            NotificationCenter.default.post(name: .Saved, object: nil)
            
            self.dismiss(animated: true, completion: nil)
            
        } catch {
            print("Erro ao salvar objeto: \(error.localizedDescription)")
        }
        
        
        
        //
        
        
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        let getContext = appDelegate.persistentContainer.viewContext
        //
        //
        //        if let entity = NSEntityDescription.entity(forEntityName: "ScheduleInfo", in: getContext) {
        //                   let objeto = NSManagedObject(entity: entity, insertInto: getContext)
        //
        //                   // Defina os atributos com os dados dos inputs do usuário
        //                   objeto.setValue(inputFieldValue.text, forKey: "atributoDeTexto")
        //                   objeto.setValue(getDateSchedule.date, forKey: "atributoDeData")
        //
        //                   // Salve o contexto CoreData
        //                   do {
        //                       try getContext.save()
        //                       print("Objeto salvo com sucesso.")
        //                   } catch {
        //                       print("Erro ao salvar objeto: \(error.localizedDescription)")
        //                   }
        //               }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        labelTeste.text = "Insira as informações necessarias"
        
        createToolBar()
        
        view.addSubview(labelTeste)
        view.addSubview(scheduleName)
        view.addSubview(inputFieldValue)
        view.addSubview(buttonDone)
        
        NSLayoutConstraint.activate([
            labelTeste.topAnchor.constraint(equalTo: view.topAnchor, constant: 48),
            labelTeste.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
            scheduleName.topAnchor.constraint(equalTo: labelTeste.topAnchor, constant: 32),
            scheduleName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            scheduleName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            inputFieldValue.topAnchor.constraint(equalTo: scheduleName.topAnchor, constant: 64),
            inputFieldValue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            inputFieldValue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            buttonDone.topAnchor.constraint(equalTo: inputFieldValue.bottomAnchor, constant: 32),
            buttonDone.heightAnchor.constraint(equalToConstant: 50),
            buttonDone.widthAnchor.constraint(equalToConstant: 225),
            buttonDone.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            buttonDone.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
        
    }
    
    
    func createToolBar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        inputFieldValue.inputAccessoryView =  toolbar
        
        inputFieldValue.inputView = getDateSchedule
        getDateSchedule.datePickerMode = .dateAndTime
    }
    
    
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        formatter.locale = Locale(identifier: "pt_BR")
        inputFieldValue.text = formatter.string(from: getDateSchedule.date)
        
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presentationController?.containerView?.backgroundColor = .systemGroupedBackground
        
    }
    
    
    
    
}


//extension SchedulerModalViewController {
//    func save(_ contexto: NSManagedObjectContext) {
//        do {
//            try contexto.save()
//        } catch {
//            
//        }
//    }
//}
