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
        setupCell()
        setupVoiceOver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecipes()
    }

    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var favoritesList: UITableView!
    @IBOutlet weak var noFavoritesLabel: UILabel!
    
    let recipeRepository = RecipeRepository()
    var recipes = [RecipeCD]()

    // MARK: - PRIVATE FUNCTIONS
    private func getRecipes() {
        recipeRepository.getRecipes { recipes in
            self.recipes = recipes
            
            displayNoFavoritesLabelIfEmptyRecipes()
            favoritesList.reloadData()
        }
    }
    
    private func setupVoiceOver() {
        favoritesList.accessibilityLabel = "Recipe's list."
    }
    
    private func displayNoFavoritesLabelIfEmptyRecipes() {
        guard !recipes.isEmpty else {
            noFavoritesLabel.isHidden = false
            return
        }
        noFavoritesLabel.isHidden = true
    }
    
    private func setupCell() {
        self.favoritesList.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
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
        
        guard let title = recipe.label, let ingredients = recipe.ingredients, let image = recipe.image else {
            return UITableViewCell()
        }
        
        cell.configureFavorite(title: title,
                       ingredients: ingredients,
                       image: image,
                       preparationTime: recipe.totalTime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(140)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToFavoritesDetails", sender: recipes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                // Always remove the data first
                try recipeRepository.deleteRecipe(recipe: recipes[indexPath.row])
                recipes.remove(at: indexPath.row)
                
                // Then, the cell
                tableView.deleteRows(at: [indexPath], with: .automatic)
                displayNoFavoritesLabelIfEmptyRecipes()
            } catch let error as RecipeRepository.RecipeError {
                presentAlert(with: error.localizedDescription)
            } catch {
                presentAlert(with: "An error occurred.")
            }
        }
    }
}

extension FavoritesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToFavoritesDetails" {
            let favoritesDetails = segue.destination as? FavoritesDetailsViewController
            let recipe = sender as? RecipeCD
            favoritesDetails?.recipe = recipe
        }
    }
}
