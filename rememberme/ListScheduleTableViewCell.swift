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
    
    lazy var labelNameSchedule: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize: 24)
        name.textAlignment = .left
        return name
    }()
    
    // MARK: - adicionando um mark
    
    lazy var labelDateSchedule: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = .systemFont(ofSize: 16)
        return date
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cardView)
        cardView.addSubview(labelNameSchedule)
        cardView.addSubview(labelDateSchedule)
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

            labelNameSchedule.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            labelNameSchedule.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            labelNameSchedule.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            labelDateSchedule.topAnchor.constraint(equalTo: labelNameSchedule.bottomAnchor, constant: 0),
            labelDateSchedule.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            labelDateSchedule.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),

        ])
    }

}

