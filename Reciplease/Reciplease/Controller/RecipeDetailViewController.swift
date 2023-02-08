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
    @IBOutlet weak var recipeIngredients: UITextView!
    @IBOutlet weak var recipeDetailsButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    var recipe: RecipeInfos?
    let recipeRepository = RecipeRepository()
    let ingredientConfiguration = IngredientConfiguration()

    // MARK: - ACTIONS
    @IBAction func addToFavorites(_ sender: Any) {
        addRecipe()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        guard let recipe = recipe else { return }
        
        recipeTitle.text = recipe.label
        recipeIngredients.text = ingredientConfiguration.formatDetailedIngredients(ingredients: recipe.ingredients)
        
        /*guard let imageData = recipe.imageData else { return }
        recipeImage.image = UIImage(data: imageData)*/
    }
    
    private func addRecipe() {
        guard let recipe = recipe else {
            return
        }
        
        do {
            try recipeRepository.addToRecipe(recipe: recipe)
            favoriteButton.image = UIImage(named: "star.fill")
        } catch let error as RecipeRepository.RecipeError {
            presentAlert(with: error.localizedDescription)
        } catch {
            presentAlert(with: "An error occurred.")
        }
    }
}
