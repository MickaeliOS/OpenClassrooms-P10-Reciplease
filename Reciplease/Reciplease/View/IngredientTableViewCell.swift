//
//  IngredientTableViewCell.swift
//  Reciplease
//
//  Created by Mickaël Horn on 01/02/2023.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    // MARK: - VIEW LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }
    
    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    // MARK: - FUNCTIONS
    func configure(title: String) {
        ingredientLabel.text = title
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func addShadow() {
        cellView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        cellView.layer.shadowRadius = 2.0
        cellView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cellView.layer.shadowOpacity = 2.0
        cellView.layer.cornerRadius = 10
    }
}
