//
//  CurrencyCell.swift
//  Currency App
//
//  Created by Kerolos on 21/05/2025.
//

import UIKit

class CurrencyCell: UICollectionViewCell {
    static let identifier = "CurrencyCell"
    
    let label: UILabel = {
          let label = UILabel()
          label.translatesAutoresizingMaskIntoConstraints = false
          label.textAlignment = .left
          label.font = UIFont.systemFont(ofSize: 17)
          label.numberOfLines = 1
          return label
      }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {

        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
             NSLayoutConstraint.activate([
                 label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                 label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                 label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                 label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
             ])
         }
    
    
    func configure(text: String) {
        label.text = text
    }
}
