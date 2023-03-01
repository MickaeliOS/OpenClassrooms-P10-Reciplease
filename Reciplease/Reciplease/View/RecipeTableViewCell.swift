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
        self.accessibilityElements = [recipeImage!, recipeTitle!, recipeFood!, recipeTimeImage!, recipeTime!]
    }
    
    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var recipeCellView: UIView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeFood: UILabel!
    @IBOutlet weak var recipeTimeImage: UIImageView!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    let ingredientConfiguration = IngredientConfiguration()
    
    // MARK: - FUNCTIONS
    func configure(title: String, ingredients: [IngredientInfos], image: String, preparationTime: Double) {
        recipeTitle.text = title
        recipeFood.text = ingredientConfiguration.formatIngredientsInOneLine(ingredientsFood: ingredients)
        recipeTime.text = "Time: \(String(preparationTime))"
        
        recipeImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(systemName: "photo"))
        
        // Proof that the images stay in cache
        /* recipeImage.sd_setImage(with: URL(string: image), completed: { (image, error, cacheType, url) in
            if cacheType == .none {
                print("PAS EN CACHE")
                // L'image n'est pas en cache, elle a été téléchargée à partir du réseau
            } else {
                print("EN CACHE")
                // L'image est en cache
            }
        }) */
        
        recipeImage.layer.cornerRadius = 10
        
        generalVoiceOverSetup(title: title, preparationTime: preparationTime)
        setupVoiceOverIngredientsInfos(ingredients: ingredients)
    }
    
    func configureFavorite(title: String, ingredients: NSOrderedSet, image: String, preparationTime: Double) {
        recipeTitle.text = title
        recipeFood.text = ingredientConfiguration.formatFavoriteIngredientsInOneLine(ingredients: ingredients)
        recipeTime.text = "Time: \(String(preparationTime))"
        recipeImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(systemName: "photo"))
        
        recipeImage.layer.cornerRadius = 10
        
        generalVoiceOverSetup(title: title, preparationTime: preparationTime)
        setupVoiceOverIngredientsSet(ingredients: ingredients)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func generalVoiceOverSetup(title: String, preparationTime: Double) {
        // accessibilityLabels
        recipeTitle.accessibilityLabel = "Recipe title."
        recipeFood.accessibilityLabel = "Recipe ingredients."
        recipeTimeImage.accessibilityLabel = "Recipe time"
        recipeTime.accessibilityLabel = "Recipe's preparation time."
        recipeImage.accessibilityLabel = "Recipe's picture."
        
        // accessibilityValues
        recipeTitle.accessibilityValue = title
        recipeTime.accessibilityValue = "\(preparationTime) minutes."

        // accessibilityHints
        recipeImage.accessibilityHint = "Show recipe's details."
    }
    
    private func setupVoiceOverIngredientsInfos(ingredients: [IngredientInfos]) {
        recipeFood.accessibilityValue = ingredientConfiguration.formatIngredientsInOneLine(ingredientsFood: ingredients)
    }
    
    private func setupVoiceOverIngredientsSet(ingredients: NSOrderedSet) {
        recipeFood.accessibilityValue = ingredientConfiguration.formatFavoriteIngredientsInOneLine(ingredients: ingredients)
    }
}
