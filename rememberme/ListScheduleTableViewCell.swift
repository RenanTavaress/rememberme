//
//  ListScheduleTableViewCell.swift
//  rememberme
//
//  Created by Renan Tavares on 11/08/23.
//

import UIKit

class ListScheduleTableViewCell: UITableViewCell {
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemGroupedBackground
        return view
       }()
    
    //
   
    
    lazy var cardNameSchedule: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize: 24)
        //name.text = "aaa"
        //print(name)
        name.textAlignment = .center
        name.backgroundColor = .red
        return name
    }()
    // MARK: - adicionando um mark
    
    lazy var cardDateSchedule: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = .systemFont(ofSize: 16)
        //date.text = "21/08/23 16:30"
       // print(date)
        return date
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cardView)
        cardView.addSubview(cardNameSchedule)
        cardView.addSubview(cardDateSchedule)
        
        self.configContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configContraints() {
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.topAnchor.constraint(equalTo:contentView.topAnchor, constant: 8),
            cardView.trailingAnchor.constraint(equalTo:contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            
            cardNameSchedule.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            cardNameSchedule.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            cardNameSchedule.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
           // cardNameSchedule.heightAnchor.constraint(equalToConstant: 100),
            cardDateSchedule.topAnchor.constraint(equalTo: cardNameSchedule.bottomAnchor, constant: 0),
            cardDateSchedule.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            cardDateSchedule.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),

        ])
    }

}

