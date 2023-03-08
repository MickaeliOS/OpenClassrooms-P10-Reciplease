//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by Mickaël Horn on 02/02/2023.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupVoiceOver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controlFavorites()
    }

    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeDetails: UITextView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var recipeTimeImage: UIImageView!
    @IBOutlet weak var recipeTime: UILabel!
    
    var recipe: RecipeAPI?
    let recipeRepository = RecipeRepository()
    let ingredientConfiguration = IngredientConfiguration()

    // MARK: - ACTIONS
    @IBAction func ManageFavorites(_ sender: Any) {
        addOrDeleteRecipe()
    }
    
    @IBAction func getDirections(_ sender: Any) {
        recipeWebPage()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        guard let recipe = recipe else { return }
        
        recipeTitle.text = recipe.label
        recipeDetails.text = ingredientConfiguration.formatDetailledIngredientsInSeparateLines(ingredients: recipe.ingredients)
        recipeTime.text = "Time: \(String(recipe.totalTime))"
        recipeImage.sd_setImage(with: URL(string: recipe.image), placeholderImage: UIImage(systemName: "photo"))
        
        getDirectionsButton.layer.cornerRadius = 10
        recipeImage.layer.cornerRadius = 10
    }
    
    private func controlFavorites() {
        guard let recipe = recipe else { return }

        recipeRepository.isFavorite(recipe: recipe) { favorite in
            guard let favorite = favorite else {
                return
            }
            
            if favorite {
                favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                favoriteButton.accessibilityValue = "In favorite"
            } else {
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                favoriteButton.accessibilityValue = "Not in favorite"
            }
        }
    }
    
    private func addRecipe() {
        guard let recipe = recipe else { return }
        
        do {
            try recipeRepository.addRecipe(recipe: recipe)
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            favoriteButton.accessibilityValue = "In favorite"
        } catch let error as RecipeRepository.RecipeError {
            presentAlert(with: error.localizedDescription)
        } catch {
            presentAlert(with: "An error occurred.")
        }
    }
    
    private func removeFromRecipes() {
        guard let recipe = recipe else { return }

        recipeRepository.getRecipe(url: recipe.url) { recipe in
            guard let recipe = recipe else { return }
            
            do {
                try recipeRepository.deleteRecipe(recipe: recipe)
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                favoriteButton.accessibilityValue = "Not in favorite"
            } catch let error as RecipeRepository.RecipeError {
                presentAlert(with: error.localizedDescription)
            } catch {
                presentAlert(with: "An error occurred.")
            }
        }
    }
    
    private func addOrDeleteRecipe() {
        let imageName = favoriteButton.currentImage?.accessibilityIdentifier
        
        if imageName == "star" {
            addRecipe()
        } else if imageName == "star.fill" {
            removeFromRecipes()
        }
    }
    
    private func recipeWebPage() {
        guard let recipe = recipe else {
            return
        }
        
        if let url = URL(string: recipe.url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func setupVoiceOver() {
        guard let recipe = recipe else { return }

        // accessibilityLabel
        recipeTitle.accessibilityLabel = "Recipe's title."
        recipeImage.accessibilityLabel = "Recipe's picture."
        recipeTimeImage.accessibilityLabel = "Recipe time"
        recipeTime.accessibilityLabel = "Recipe's preparation time."
        recipeDetails.accessibilityLabel = "Recipe's detailled ingredients."
        favoriteButton.accessibilityLabel = "Favorites."
        
        // accessibilityValue
        recipeTitle.accessibilityValue = recipeTitle.text ?? ""
        recipeTime.accessibilityValue = "\(recipe.totalTime) minutes."

        // accessibilityHint
        getDirectionsButton.accessibilityHint = "Recipe's instructions web page."
        favoriteButton.accessibilityHint = "Add or remove the recipe from your favorites."
    }
}
