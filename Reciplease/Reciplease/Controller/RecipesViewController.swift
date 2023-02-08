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
    }
    
    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var recipeList: UITableView!
    @IBOutlet weak var noRecipesLabel: UILabel!
    
    let apiCallCenter = APICallCenter()
    var ingredientConfiguration = IngredientConfiguration()
    var recipes = [RecipeInfos]()
    
    // MARK: - PRIVATE FUNCTIONS
    private func getRecipes() {
        apiCallCenter.delegate = self
        
        let ingredients = ingredientConfiguration.formatIngredientsForAPIRequest(ingredients: ingredientConfiguration.ingredients)
        apiCallCenter.getRecipes(ingredients: ingredients, nbIngredients: String(ingredientConfiguration.ingredients.count))
    }
    
    /*private func getImages() {
        apiCallCenter.getImages(recipes: recipes)
    }*/
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
    /*func getImagesDidFinish(_ result: [RecipeInfos]) {
        self.recipes = result
        self.recipeList.reloadData()
    }
    
    func getImagesDidFail() {
        //presentAlert(with: "Something went wrong while retrieving the image, please try again.")
        // Si on doit afficher 300 images et qu'il y en a 50 qui ne sont pas là, on va déclencher 50 fois le presentAlert()
        print("Something went wrong while retrieving the image.")
    }*/
    
    func getRecipesDidFinish(_ result: [RecipeInfos]) {
        if result.isEmpty {
            return
        }
        self.recipes = result
        self.recipeList.reloadData()
        
        // Now we need the images
        //getImages()
    }
    
    func getRecipesDidFail() {
        presentAlert(with: "Something went wrong, please try again.")
    }
}
