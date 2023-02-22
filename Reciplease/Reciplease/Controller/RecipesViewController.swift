//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by Mickaël Horn on 01/02/2023.
//

import UIKit

class RecipesViewController: UIViewController {
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipes()
        setupVoiceOver()
    }
    
    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var recipeList: UITableView!
    @IBOutlet weak var noRecipesLabel: UILabel!
    @IBOutlet weak var backButton: UINavigationItem!
    
    let apiCallCenter = APICallCenter()
    var ingredientConfiguration = IngredientConfiguration()
    var recipes = [RecipeInfos]()
    var nextPage: Next?
    
    // MARK: - PRIVATE FUNCTIONS
    private func getRecipes() {
        // To lighten the Controller, i'm using an API call file
        apiCallCenter.delegate = self
        
        let ingredients = ingredientConfiguration.ingredients.joined(separator: " ")
        apiCallCenter.getRecipes(ingredients: ingredients, nbIngredients: String(ingredientConfiguration.ingredients.count))
    }
    
    private func getNextPage(nextPage: Next) {
        apiCallCenter.getNextPage(nextPage: nextPage)
    }
    
    private func setupVoiceOver() {
        recipeList.accessibilityLabel = "Recipe's list."
    }
}

// MARK: - EXTENSIONS
extension RecipesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        let recipe = recipes[indexPath.row]
        
        cell.configure(title: recipe.label,
                       ingredients: recipe.ingredients,
                       image: recipe.image,
                       preparationTime: recipe.totalTime,
                       score: recipe.yield)
        
        print("MKA - Recette n° \(indexPath.row) : \(recipe.label)")
        
        if indexPath.row == recipes.count - 1 {
            guard let nextPage = nextPage else { return UITableViewCell() }
            getNextPage(nextPage: nextPage)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(140)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToRecipeDetail", sender: recipes[indexPath.row])
    }
}

extension RecipesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRecipeDetail" {
            let recipesVC = segue.destination as? RecipeDetailViewController
            let recipe = sender as? RecipeInfos
            recipesVC?.recipe = recipe
        }
    }
}

extension RecipesViewController: APICallCenterDelegate {
    func getRecipesDidFinish(result: [RecipeInfos]?, nextPage: Next?) {
        guard let result = result else { return }
        
        noRecipesLabel.isHidden = true

        if let nextPage = nextPage {
            self.nextPage = nextPage
        }
        
        recipes = result
        recipeList.reloadData()
                
        //print("MKA - Next page's link : \(self.nextPage.href)")
    }
        
    func getRecipesDidFailWithError() {
        presentAlert(with: "Something went wrong, please try again.")
    }
    
    func getRecipesDidFailWithIncorrectResponse() {
        presentAlert(with: "Something went wrong, please try again.")
    }
    
    func getNextPageDidFinish(result: [RecipeInfos]?, nextPage: Next?) {
        guard let result = result else { return }

        if let nextPage = nextPage {
            self.nextPage = nextPage
        }
        
        recipes = result
        recipeList.reloadData()
    }
    
    func getNextPageDidFailWithError() {
        presentAlert(with: "Something went wrong, please try again.")
    }
    
    func getNextPageDidFailWithIncorrectResponse() {
        presentAlert(with: "Something went wrong, please try again.")
    }
}
