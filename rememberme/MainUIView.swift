//
//  MainUIView.swift
//  rememberme
//
//  Created by Renan Tavares on 21/07/23.
//

import UIKit

class MainUIView: UIView {
//    lazy var cardView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .secondarySystemGroupedBackground
//        return view
//    }()
//
    
//    lazy var cardNameSchedule: UILabel = {
//        let name = UILabel()
//        name.text = "Testando"
//        name.translatesAutoresizingMaskIntoConstraints = false
//        return name
//    }()
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       // self.addSubview(self.cardView)
       // cardView.addSubview(cardNameSchedule)
        self.configContraints()
    }
    
    required init?(coder: NSCoder){
        fatalError("erro")
    }
    
    
    private func configContraints() {
        
//        NSLayoutConstraint.activate([
//            self.cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
//            self.cardView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
//            self.cardView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant: -24),
//            self.cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -664),
//
//            cardNameSchedule.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
//            cardNameSchedule.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
//
//        ])
    }
}

