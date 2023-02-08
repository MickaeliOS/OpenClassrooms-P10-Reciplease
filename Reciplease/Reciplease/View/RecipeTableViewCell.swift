//
//  recipeTableViewCell.swift
//  Reciplease
//
//  Created by Mickaël Horn on 01/02/2023.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    // MARK: - VIEW LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var recipeCellView: UIView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeFood: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeScore: UIButton!
    @IBOutlet weak var recipeTime: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let ingredientConfiguration = IngredientConfiguration()
    
    // MARK: - FUNCTIONS
    func configure(title: String, ingredients: [IngredientInfos], image: Data?, preparationTime: Double, score: Double) {
        recipeTitle.text = title
        recipeFood.text = ingredientConfiguration.formatMainIngredientsInOneLine(ingredientsFood: ingredients)
        recipeScore.titleLabel?.text = String(score)
        recipeTime.titleLabel?.text = String(preparationTime)
        
        // At first, we only loads the recipes, so the image will be nil
        guard let image = image else { return }
        
        // But right after, the image data is here, so we present it
        recipeImage.image = UIImage(data: image)
        activityIndicator.isHidden = true
    }
}
