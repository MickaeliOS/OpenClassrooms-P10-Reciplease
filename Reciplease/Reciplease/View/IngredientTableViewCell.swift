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
        customTableViewCell()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        customTableViewCell()
    }
    
    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var swipeToDeleteImage: UIImageView!
    
    // MARK: - FUNCTIONS
    func configure(title: String) {
        ingredientLabel.text = title
        setupVoiceOver(title: title)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func customTableViewCell() {
        cellView.layer.borderColor = UIColor(named: "IngredientTableViewCell")?.cgColor
        cellView.layer.borderWidth = 1.0
        cellView.layer.cornerRadius = 10
    }
    
    private func setupVoiceOver(title: String) {
        // Not allowing accessibility for the cell itself
        self.isAccessibilityElement = false
        
        // But we enable it for every items in the cell
        self.accessibilityElements = [ingredientLabel!, swipeToDeleteImage!]
        
        // accessibilityLabels
        ingredientLabel.accessibilityLabel = "Ingredient."
        swipeToDeleteImage.accessibilityLabel = "Swipe to delete."

        // accessibilityValues
        ingredientLabel.accessibilityValue = title
    }
}
