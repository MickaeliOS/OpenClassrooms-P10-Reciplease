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
        self.accessibilityElements = [recipeImage!, recipeTitle!, recipeFood!, recipeScoreImage!, recipeTimeImage!, recipeScore!, recipeTime!]
    }
    
    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var recipeCellView: UIView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeFood: UILabel!
    @IBOutlet weak var recipeScoreImage: UIImageView!
    @IBOutlet weak var recipeTimeImage: UIImageView!
    @IBOutlet weak var recipeScore: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let ingredientConfiguration = IngredientConfiguration()
    
    // MARK: - FUNCTIONS
    func configure(title: String, ingredients: [IngredientInfos], image: String, preparationTime: Double, score: Double) {
        recipeTitle.text = title
        recipeFood.text = ingredientConfiguration.formatIngredientsInOneLine(ingredientsFood: ingredients)
        recipeScore.text = String(score)
        recipeTime.text = String(preparationTime)
        
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
        recipeImage.layer.cornerRadius = 10
        
        generalVoiceOverSetup(title: title, preparationTime: preparationTime, score: score)
        setupVoiceOverIngredientsInfos(ingredients: ingredients)
    }
    
    func configureFavorite(title: String, ingredients: NSOrderedSet, image: String, preparationTime: Double, score: Double) {
        recipeTitle.text = title
        recipeFood.text = ingredientConfiguration.formatFavoriteIngredientsInOneLine(ingredientsFood: ingredients)
        recipeScore.text = String(score)
        recipeTime.text = String(preparationTime)
        recipeImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(systemName: "photo"))
        
        recipeImage.layer.cornerRadius = 10
        
        generalVoiceOverSetup(title: title, preparationTime: preparationTime, score: score)
        setupVoiceOverIngredientsSet(ingredients: ingredients)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func generalVoiceOverSetup(title: String, preparationTime: Double, score: Double) {
        // accessibilityLabels
        recipeTitle.accessibilityLabel = "Recipe title."
        recipeFood.accessibilityLabel = "Recipe ingredients."
        recipeScoreImage.accessibilityLabel = "Recipe score"
        recipeTimeImage.accessibilityLabel = "Recipe time"
        recipeScore.accessibilityLabel = "Recipe's score."
        recipeTime.accessibilityLabel = "Recipe's preparation time."
        recipeImage.accessibilityLabel = "Recipe's picture."
        
        // accessibilityValues
        recipeTitle.accessibilityValue = title
        recipeScore.accessibilityValue = "\(score) upvotes."
        recipeTime.accessibilityValue = "\(preparationTime) minutes."

        // accessibilityHints
        recipeImage.accessibilityHint = "Show recipe's details."
    }
    
    private func setupVoiceOverIngredientsInfos(ingredients: [IngredientInfos]) {
        recipeFood.accessibilityValue = ingredientConfiguration.formatIngredientsInOneLine(ingredientsFood: ingredients)
    }
    
    private func setupVoiceOverIngredientsSet(ingredients: NSOrderedSet) {
        recipeFood.accessibilityValue = ingredientConfiguration.formatFavoriteIngredientsInOneLine(ingredientsFood: ingredients)
    }
}
