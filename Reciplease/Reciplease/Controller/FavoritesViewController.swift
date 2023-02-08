//
//  FavoritesViewController.swift
//  Reciplease
//
//  Created by Mickaël Horn on 06/02/2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecipes()
    }

    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var favoritesList: UITableView!
    let recipeRepository = RecipeRepository()
    var recipes = [Recipe]()

    // MARK: - PRIVATE FUNCTIONS
    private func getRecipes() {
        recipeRepository.getRecipe { recipes in
            self.recipes = recipes
            favoritesList.reloadData()
        }
    }
}

// MARK: - EXTENSIONS
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        let recipe = recipes[indexPath.row]
        
        guard let title = recipe.title, let ingredients = recipe.ingredients, let image = recipe.image else {
            return UITableViewCell()
        }
        
        //TODO : Changer ingredients
        cell.configure(title: title,
                       ingredients: [IngredientInfos](),
                       image: image,
                       preparationTime: recipe.time,
                       score: recipe.score)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(140)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToRecipeDetail", sender: recipes[indexPath.row])
    }
}

/*extension RecipesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRecipeDetail" {
            let recipesVC = segue.destination as? RecipeDetailViewController
            let recipe = sender as? RecipeAPI
            recipesVC?.recipe = recipe
        }
    }
}*/
