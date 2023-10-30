//
//  ViewController.swift
//  rememberme
//
//  Created by Renan Tavares on 19/07/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    // var models:[ScheduleCoreData2] = []
    var scheduleModel = [ScheduleCoreData]()
    // var test:[(String, Date)] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //var screen: MainUIView?
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.automaticallyAdjustsScrollIndicatorInsets = false
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.separatorColor = .none
        tableview.separatorStyle = .none
        
        tableview.backgroundColor = .systemGroupedBackground
        title = "Compromissos"
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(ListScheduleTableViewCell.self, forCellReuseIdentifier: "ListScheduleTableViewCell")
        return tableview
    }()
    
    //    override func loadView() {
    //        self.screen = MainUIView()
    //        self.view = self.screen
    //
    //    }
    
    
    
    //    public func getSchedules(){
    //        print("Get Schedules!!!")
    //        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
    //            return
    //        }
    //
    //        let context = appDelegate.persistentContainer.viewContext
    //        let fetchRequest = NSFetchRequest<ScheduleCoreData2>(entityName: "ScheduleCoreData")
    //        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //
    //        if  let fetchedModels = try? context.fetch<ScheduleCoreData2>(ScheduleCoreData2.fetchRequest()) {
    //            print("Entrei!")
    //            models = fetchedModels.compactMap { $0 as? ScheduleCoreData }
    //            models = fetchedModels
    //            scheduleModel = fetchedModels as? [ScheduleCoreData2] ?? []
    //        }
    //        do {
    //            scheduleModel = try context.fetch(fetchRequest)
    //            print("Entrei!")
    //        } catch {
    //            print(error)
    //        }
    //
    //        scheduleModel = fetchedModels
    //
    //        DispatchQueue.main.async {
    //            print("reload Data!!!")
    //            print("Os models são \(self.models[0].scheduleName)")
    //
    //        }
    //
    //        print(scheduleModel.count)
    //
    //
    //    }
    
    func getAllItems(){
        
        do {
            scheduleModel = try context.fetch(ScheduleCoreData.fetchRequest())
            print(scheduleModel)
        } catch {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(dataSaved(notification:)), name: NSNotification.Name("load"), object: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Adicionar", image: UIImage(systemName: "plus.circle"), target: self, action: #selector(addTapped))
        navigationController?.navigationBar.prefersLargeTitles = true
      
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor , constant: 8),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),

        ])
        
        print(scheduleModel.count)
        
        
        //        DispatchQueue.main.async {
        //            print("reload Data!!!")
        //            // print("Os models são \(self.models[0].scheduleName)")
        //
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllItems()
        self.tableView.reloadData()
        
    }
    
    
    @objc func dataSaved(notification: NSNotification) {
          // Atualize sua tableView aqui
        guard let schedule = notification.object as? ScheduleCoreData else { return }
        self.scheduleModel.append(schedule)
        self.tableView.reloadData()
        print("Foi atualizado")
        print(scheduleModel.count)
      }
    
    
    
    @objc func addTapped() {
        let modalSchedule = SchedulerModalViewController()
        present(modalSchedule, animated: true, completion: nil)
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return scheduleModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = scheduleModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListScheduleTableViewCell", for: indexPath) as! ListScheduleTableViewCell
        cell.selectionStyle = .none
        //  cell.cardNameSchedule.text = model.scheduleName
        if let cellName = model.scheduleName {
            cell.cardNameSchedule.text = cellName
        }
        
        //print(model.scheduleName)
        
        //        if let cellName = model.scheduleName {
        //            cell.cardNameSchedule.text =  cellName
        //        }
        //        if model.scheduleName == nil {
        //            cell.cardNameSchedule.text = "BLEAHHHHH"
        //            print("Estava vazio valor da celula \(cell)")
        //        } else {
        //            print("Coloquei \(model.scheduleName) na celula \(cell)  indexPath:\(indexPath)")
        //        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        if let date = model.dateSchedule {
            cell.cardDateSchedule.text = formatter.string(from: date )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension NSNotification.Name {
    static let Saved = Notification.Name("Saved")
}

