//
//  recipeTableViewCell.swift
//  Reciplease
//
//  Created by Mickaël Horn on 01/02/2023.
//

import UIKit
import SDWebImage

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - VIEW LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Not allowing accessibility for the cell itself
        self.isAccessibilityElement = false
        
        // But we enable it for every items in the cell
        self.accessibilityElements = [recipeTitle!, recipeFood!, recipeImage!, recipeScore!, recipeTime!]
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
    func configure(title: String, ingredients: [IngredientInfos], image: String, preparationTime: Double, score: Double) {
        recipeTitle.text = title
        recipeFood.text = ingredientConfiguration.formatIngredientsInOneLine(ingredientsFood: ingredients)
        recipeScore.titleLabel?.text = String(score)
        recipeTime.titleLabel?.text = String(preparationTime)
        
        //recipeImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(systemName: "photo"))
        
        recipeImage.sd_setImage(with: URL(string: image), completed: { (image, error, cacheType, url) in
            if cacheType == .none {
                print("PAS EN CACHE")
                // L'image n'est pas en cache, elle a été téléchargée à partir du réseau
            } else {
                print("EN CACHE")
                // L'image est en cache
            }
        })
    }
    
    func configureFavorite(title: String, ingredients: NSSet, image: String, preparationTime: Double, score: Double) {
        recipeTitle.text = title
        recipeFood.text = ingredientConfiguration.formatFavoriteIngredientsInOneLine(ingredientsFood: ingredients)
        recipeScore.titleLabel?.text = String(score)
        recipeTime.titleLabel?.text = String(preparationTime)
        
        recipeImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(systemName: "photo"))
    }
}
