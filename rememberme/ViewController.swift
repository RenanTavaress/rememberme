//
//  ViewController.swift
//  rememberme
//
//  Created by Renan Tavares on 19/07/23.
//

import UIKit

class ViewController: UIViewController {
    //var screen: MainUIView?
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.automaticallyAdjustsScrollIndicatorInsets = false
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.separatorColor = .none
        tableview.separatorStyle = .none
        
        tableview.backgroundColor = .red
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Adicionar", image: UIImage(systemName: "plus.circle"), target: self, action: #selector(addTapped))
        navigationController?.navigationBar.prefersLargeTitles = true
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor , constant: 8),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
        
        ])
        
    }
    
    
    
    
    @objc func addTapped() {
            let modalSchedule = SchedulerModalViewController()
            present(modalSchedule, animated: true, completion: nil)
      }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListScheduleTableViewCell", for: indexPath) as? ListScheduleTableViewCell
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

