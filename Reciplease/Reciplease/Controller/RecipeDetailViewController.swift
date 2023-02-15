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
    }

    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeDetails: UITextView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    var recipe: RecipeInfos?
    let recipeRepository = RecipeRepository()
    let ingredientConfiguration = IngredientConfiguration()

    // MARK: - ACTIONS
    @IBAction func favoritesAddOrRemove(_ sender: Any) {
        if favoriteButton.image?.accessibilityIdentifier == "star" {
            addRecipe()
        } else {
            //removeRecipe()
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
        recipeDetails.text = ingredientConfiguration.formatInstructions(ingredients: recipe.ingredients)
        
        // recipeImage.sd_setImage(with: URL(string: recipe.image), placeholderImage: UIImage(systemName: "photo"))
        recipeImage.sd_setImage(with: URL(string: recipe.image), completed: { (image, error, cacheType, url) in
            if cacheType == .none {
                print("PAS EN CACHE")
            } else {
                print("EN CACHE")
            }
        })
    }
    
    private func addRecipe() {
        guard let recipe = recipe else { return }
        
        do {
            try recipeRepository.addToRecipe(recipe: recipe)
            favoriteButton.image = UIImage(systemName: "star.fill")
        } catch let error as RecipeRepository.RecipeError {
            presentAlert(with: error.localizedDescription)
        } catch {
            presentAlert(with: "An error occurred.")
        }
    }
    
    /*private func removeRecipe() {
        guard let recipe = recipe else { return }

        do {
            // Always remove the data first
            try recipeRepository.deleteRecipe(recipe: recipe)
    

        } catch let error as RecipeRepository.RecipeError {
            presentAlert(with: error.localizedDescription)
        } catch {
            presentAlert(with: "An error occurred.")
        }
    }*/
}
