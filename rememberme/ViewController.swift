//
//  ViewController.swift
//  rememberme
//
//  Created by Renan Tavares on 19/07/23.
//

import UIKit
import CoreData
import EventKit
import EventKitUI
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    var store = EKEventStore()
    var scheduleModel = [ScheduleCoreData]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var audioPlayer: AVAudioPlayer?
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.automaticallyAdjustsScrollIndicatorInsets = false
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.separatorColor = .none
        tableview.separatorStyle = .none
        tableview.backgroundColor = .systemGroupedBackground
        tableview.showsVerticalScrollIndicator = false
        title = "Compromissos"
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(ListScheduleTableViewCell.self, forCellReuseIdentifier: "ListScheduleTableViewCell")
        return tableview
    }()
    
    func getAllItems(){
        do {
            scheduleModel = try context.fetch(ScheduleCoreData.fetchRequest())
        } catch {
            print("erro")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(dataSaved(notification:)), name: Notification.Name("Saved"), object: nil)
        let config = UIImage.SymbolConfiguration(pointSize: 38, weight: .regular, scale: .default)
        
        if #available(iOS 16.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Adicionar", image: UIImage(systemName: "plus", withConfiguration: config), target: self, action: #selector(addTapped))
        } else {
            let addButton = UIBarButtonItem(title: "Adicionar", style: .plain, target: self, action: #selector(addTapped))
            addButton.image = UIImage(systemName: "plus", withConfiguration: config)
            navigationItem.rightBarButtonItem = addButton
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
    
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor , constant: 8),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
        ])
        
        DispatchQueue.main.async {
            self.getAllItems()
            self.tableView.reloadData()
        }
    }
    
    @objc func dataSaved(notification: NSNotification) {
        guard notification.object is ScheduleCoreData else { return }
        getAllItems()
        self.tableView.reloadData()
    }

    @objc func addTapped() {
        let status = EKEventStore.authorizationStatus(for: .event)
        if status == .authorized {
            let modalSchedule = SchedulerModalViewController()
            let navigationController = UINavigationController(rootViewController: modalSchedule)
            self.present(navigationController, animated: true, completion: nil)
        } else {
            if #available(iOS 17.0, *) {
                store.requestFullAccessToEvents { succes, error in
                    if succes && error == nil {
                        DispatchQueue.main.sync {
                            let modalSchedule = SchedulerModalViewController()
                            let navigationController = UINavigationController(rootViewController: modalSchedule)
                            self.present(navigationController, animated: true, completion: nil)
                        }
                    }
                }
            } else {
                store.requestAccess(to: .event) { (succes, error) in
                    if succes && error == nil {
                        DispatchQueue.main.sync {
                            let modalSchedule = SchedulerModalViewController()
                            let navigationController = UINavigationController(rootViewController: modalSchedule)
                            self.present(navigationController, animated: true, completion: nil)
                        }
                    }
                    
                }
            }
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        if scheduleModel.isEmpty {
            self.tableView.setEmptyMessage("Não há compromissos marcados")
            return 0
        } else {
            self.tableView.restore()
            return scheduleModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = scheduleModel[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListScheduleTableViewCell", for: indexPath) as! ListScheduleTableViewCell
        
        cell.selectionStyle = .none
        cell.backgroundColor = .systemGroupedBackground
        if let cellName = model.name {
            cell.labelNameSchedule.text = cellName
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let date = model.startDate {
            cell.labelStartDateSchedule.text = formatter.string(from: date)
        }
        
        if let endDate = model.endDate {
            cell.labelEndDateSchedule.text = formatter.string(from: endDate)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        
        context.delete(scheduleModel.remove(at: indexPath.section))
        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
        do {
            try context.save()
        } catch {
            print("deu ruim")
        }
        
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.textColor = .secondaryLabel
            messageLabel.textAlignment = .center
            messageLabel.font = .systemFont(ofSize: 20)
            messageLabel.sizeToFit()

            self.backgroundView = messageLabel
            self.separatorStyle = .none
        }

        func restore() {
            self.backgroundView = nil
            self.separatorStyle = .singleLine
        }
}
