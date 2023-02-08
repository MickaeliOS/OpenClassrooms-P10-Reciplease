//
//  IngredientsViewController.swift
//  Reciplease
//
//  Created by Mickaël Horn on 01/02/2023.
//

import UIKit

class IngredientsViewController: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }

    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var addIngredientButton: UIButton!
    @IBOutlet weak var ingredientList: UITableView!
    @IBOutlet weak var searchRecipesButton: UIButton!
    @IBOutlet weak var addIngredientView: UIView!
    @IBOutlet weak var clearIngredientsButton: UIButton!
    
    let ingredientConfiguration = IngredientConfiguration()
    
    // MARK: - ACTIONS
    @IBAction func addIngredient(_ sender: Any) {
        addIngredient()
    }
    
    @IBAction func searchRecipes(_ sender: Any) {
        prepareSearchRecipes()
    }
    
    @IBAction func clearIngredients(_ sender: Any) {
        deleteAllIngredients()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func deleteAllIngredients() {
        ingredientConfiguration.removeAllIngredients()
        ingredientList.reloadData()
    }
        
    private func setupInterface() {
        addIngredientButton.layer.cornerRadius = 10
        addIngredientView.layer.cornerRadius = 10
        searchRecipesButton.layer.cornerRadius = 10
        clearIngredientsButton.layer.cornerRadius = 10
        
        ingredientTextField.addBottomBorder()
    }
    
    private func addIngredient() {
        do {
            try ingredientConfiguration.addIngredient(ingredient: ingredientTextField.text)
            ingredientTextField.text = ""
            ingredientList.reloadData()
        } catch let error as IngredientConfiguration.IngredientError {
            presentAlert(with: error.localizedDescription)
        } catch {
            presentAlert(with: "An error occurred.")
        }
    }
    
    private func prepareSearchRecipes() {
        guard !ingredientConfiguration.ingredients.isEmpty else {
            presentAlert(with: "No ingredient in the list, please add one at least.")
            return
        }
                
        performSegue(withIdentifier: "segueToRecipes", sender: ingredientConfiguration)
    }
}

// MARK: - EXTENSIONS
extension IngredientsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRecipes" {
            let recipesVC = segue.destination as? RecipesViewController
            let ingredients = sender as? IngredientConfiguration
            recipesVC?.ingredientConfiguration = ingredients!
        }
    }
}

extension IngredientsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientTextField.resignFirstResponder()
        return true
    }
}

extension IngredientsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientConfiguration.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        
        let ingredient = ingredientConfiguration.ingredients[indexPath.row]
        cell.configure(title: ingredient)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(75)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Always remove the data first
            ingredientConfiguration.removeIngredients(at: indexPath.row)
            
            // Then, the cell
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
