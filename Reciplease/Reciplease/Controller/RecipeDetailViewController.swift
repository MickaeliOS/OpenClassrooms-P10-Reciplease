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
        
        guard let recipe = recipe else { return }

        recipeRepository.isFavorite(recipe: recipe) { favorite in
            guard let favorite = favorite else {
                return
            }
            
            if favorite {
                //favoriteButton.image = UIImage(systemName: "star.fill")
                favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                //favoriteButton.image = UIImage(systemName: "star")
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }

    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeDetails: UITextView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    var recipe: RecipeInfos?
    let recipeRepository = RecipeRepository()
    let ingredientConfiguration = IngredientConfiguration()

    // MARK: - ACTIONS
    @IBAction func ManageFavorites(_ sender: Any) {
        //let imageName = favoriteButton.image?.accessibilityIdentifier
        let imageName = favoriteButton.currentImage?.accessibilityIdentifier
        
        if imageName == "star" {
            addRecipe()
        } else if imageName == "star.fill" {
            removeFromRecipes()
        }
    }
    
    @IBAction func getDirections(_ sender: Any) {
        guard let recipe = recipe else {
            return
        }
        
        if let url = URL(string: recipe.url) {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        guard let recipe = recipe else { return }
        
        recipeTitle.text = recipe.label
        recipeDetails.text = ingredientConfiguration.formatDetailledIngredientsInSeparateLines(ingredients: recipe.ingredients)
        
        recipeImage.sd_setImage(with: URL(string: recipe.image), placeholderImage: UIImage(systemName: "photo"))
        
        getDirectionsButton.layer.cornerRadius = 10
        recipeImage.layer.cornerRadius = 10
    }
    
    private func addRecipe() {
        guard let recipe = recipe else { return }
        
        do {
            try recipeRepository.addRecipe(recipe: recipe)
            //favoriteButton.image = UIImage(systemName: "star.fill")
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
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
                //favoriteButton.image = UIImage(systemName: "star")
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            } catch let error as RecipeRepository.RecipeError {
                presentAlert(with: error.localizedDescription)
            } catch {
                presentAlert(with: "An error occurred.")
            }
        }
    }
    
    private func setupVoiceOver() {
        // accessibilityLabel
        recipeTitle.accessibilityLabel = "Recipe's title."
        recipeImage.accessibilityLabel = "Recipe's picture."
        recipeDetails.accessibilityLabel = "Recipe's detailled ingredients."
        favoriteButton.accessibilityLabel = "Favorites."
        
        // accessibilityValue
        recipeTitle.accessibilityValue = recipeTitle.text ?? ""
        
        // accessibilityHint
        getDirectionsButton.accessibilityHint = "Recipe's instructions web page."
        favoriteButton.accessibilityHint = "Add the recipe to your favorites."
    }
    
    /*private func removeRecipe() {
        guard let recipe = recipe else { return }

        do {
            try recipeRepository.deleteRecipe(recipeInfos: recipe)
            favoriteButton.image = UIImage(systemName: "star")

        } catch let error as RecipeRepository.RecipeError {
            presentAlert(with: error.localizedDescription)
        } catch {
            presentAlert(with: "An error occurred.")
        }
    }*/
}
