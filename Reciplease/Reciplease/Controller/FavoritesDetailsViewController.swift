//
//  FavoritesDetailsViewController.swift
//  Reciplease
//
//  Created by Mickaël Horn on 15/02/2023.
//

import UIKit

class FavoritesDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupVoiceOver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //TODO: Gérer les étoiles lors du passage d'un contrôleur à l'autre
        
        guard let recipe = recipe else {
            guard let url = url else { return }

            recipeRepository.isFavorite(url: url) { favorite in
                guard let favorite = favorite else {
                    return
                }
                
                if favorite {
                    favoriteButton.image = UIImage(systemName: "star.fill")
                } else {
                    favoriteButton.image = UIImage(systemName: "star")
                }
            }

            
            return
        }
    }

    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeDetails: UITextView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    var recipe: Recipe?
    var url: String?
    let ingredientConfiguration = IngredientConfiguration()
    let recipeRepository = RecipeRepository()
    
    @IBAction func getDirections(_ sender: UIButton) {
        guard let recipe = recipe, let url = recipe.url else {
            return
        }
        
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func removeFromFavorites(_ sender: UIBarButtonItem) {
        guard let recipe = recipe else { return }
        removeFavorite(recipe: recipe)
    }
    
    private func setupInterface() {
        guard let recipe = recipe,
              let ingredients = recipe.ingredients,
              let image = recipe.image,
              let url = recipe.url
        else { return }
        
        self.url = url
        recipeTitle.text = recipe.label
        recipeDetails.text = ingredientConfiguration.formatFavoritesInstructions(ingredients: ingredients)
        
        // recipeImage.sd_setImage(with: URL(string: recipe.image), placeholderImage: UIImage(systemName: "photo"))
        recipeImage.sd_setImage(with: URL(string: image), completed: { (image, error, cacheType, url) in
            if cacheType == .none {
                print("PAS EN CACHE")
            } else {
                print("EN CACHE")
            }
        })
        
        recipeImage.layer.cornerRadius = 10
        getDirectionsButton.layer.cornerRadius = 10
    }
    
    /*private func addToFavorites(recipe: Recipe) {
        do {
            try recipeRepository.addToRecipe(recipe: recipe)

        } catch let error as RecipeRepository.RecipeError {
            presentAlert(with: error.localizedDescription)
        } catch {
            presentAlert(with: "An error occurred.")
        }
    }*/
    
    private func removeFavorite(recipe: Recipe) {
        do {
            try recipeRepository.deleteRecipe(recipe: recipe)
            favoriteButton.image = UIImage(systemName: "star")
            self.recipe = nil
            
        } catch let error as RecipeRepository.RecipeError {
            presentAlert(with: error.localizedDescription)
        } catch {
            presentAlert(with: "An error occurred.")
        }
    }
    
    private func setupVoiceOver() {
        // accessibilityLabel
        recipeTitle.accessibilityLabel = "Recipe's title."
        recipeImage.accessibilityLabel = "Recipe's picture."
        recipeDetails.accessibilityLabel = "Recipe's instructions."
        favoriteButton.accessibilityLabel = "Favorites."
        
        // accessibilityValue
        recipeTitle.accessibilityValue = recipeTitle.text ?? ""
        
        // accessibilityHint
        getDirectionsButton.accessibilityHint = "Recipe's instructions web page."
        favoriteButton.accessibilityHint = "Add the recipe to your favorites."
    }
}
