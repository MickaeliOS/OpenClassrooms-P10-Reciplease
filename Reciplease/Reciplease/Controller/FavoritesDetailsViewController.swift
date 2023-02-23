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
        recipeControl()
    }

    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeDetails: UITextView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    var recipe: Recipe?
    var copiedRecipe: RecipeInfos?
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
    
    @IBAction func ManageFavorites(_ sender: UIBarButtonItem) {
        let imageName = favoriteButton.image?.accessibilityIdentifier
        
        if imageName == "star" {
            addRecipe()
        } else if imageName == "star.fill" {
            removeFromFavorite()
        }
    }
    
    private func setupInterface() {
        guard let recipe = recipe,
              let ingredients = recipe.ingredients,
              let image = recipe.image
        else { return }
        
        copiedRecipe = recipeRepository.copyRecipe(recipe: recipe)
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
    
    private func addRecipe() {
        guard let copiedRecipe = copiedRecipe else { return }
        
        do {
            try recipeRepository.addToRecipe(recipe: copiedRecipe)
            reloadRecipe(copiedRecipe: copiedRecipe)
            favoriteButton.image = UIImage(systemName: "star.fill")
        } catch let error as RecipeRepository.RecipeError {
            presentAlert(with: error.localizedDescription)
        } catch {
            presentAlert(with: "An error occurred.")
        }
    }
    
    private func removeFromFavorite() {
        guard let recipe = recipe else { return }

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
    
    private func recipeControl() {
        guard let copiedRecipe = copiedRecipe else { return }
        
        recipeRepository.isFavorite(url: copiedRecipe.url) { favorite in
            guard let favorite = favorite else {
                return
            }
            
            if favorite {
                favoriteButton.image = UIImage(systemName: "star.fill")
                
                // If recipe is nil but exists in favorites, it means the recipe has been deleted previously but re-added after
                // So we reload it
                reloadRecipe(copiedRecipe: copiedRecipe)
                
            } else {
                favoriteButton.image = UIImage(systemName: "star")
            }
        }
    }
    
    private func reloadRecipe(copiedRecipe: RecipeInfos) {
        guard let _ = recipe else {
            recipeRepository.getRecipe(url: copiedRecipe.url, completion: { recipe in
                guard let recipe = recipe else { return }
                self.recipe = recipe
            })
            return
        }
    }
}
