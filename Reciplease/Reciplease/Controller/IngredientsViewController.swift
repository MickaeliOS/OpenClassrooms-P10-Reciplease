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
        setupVoiceOver()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ingredientListControl), name: .ingredientsListModified, object: nil)
    }

    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var applicationTitle: UINavigationItem!
    @IBOutlet weak var addIngredientView: UIView!
    @IBOutlet weak var inYourFridgeLabel: UILabel!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var addIngredientButton: UIButton!
    @IBOutlet weak var yourIngredientsLabel: UILabel!
    @IBOutlet weak var clearIngredientsButton: UIButton!
    @IBOutlet weak var ingredientList: UITableView!
    @IBOutlet weak var searchRecipesButton: UIButton!
    @IBOutlet weak var searchTabBar: UITabBarItem!
    @IBOutlet weak var ingredientsStackView: UIStackView!
    @IBOutlet weak var ingredientListView: UIView!
    @IBOutlet weak var noIngredientsLabel: UILabel!
    
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
    private func setupInterface() {        
        addIngredientButton.layer.cornerRadius = 10
        addIngredientView.layer.cornerRadius = 10
        searchRecipesButton.layer.cornerRadius = 10
        clearIngredientsButton.layer.cornerRadius = 10
        ingredientsStackView.layer.cornerRadius = 10
        ingredientListView.layer.cornerRadius = 10
        
        ingredientTextField.addBottomBorder()
    }
    
    private func setupVoiceOver() {
        applicationTitle.accessibilityLabel = "Application's name, Reciplease."
        ingredientTextField.accessibilityLabel = "A TextField to put your ingredients."
        ingredientTextField.accessibilityValue = "Example : lemon, cheese, sausage."
        addIngredientButton.accessibilityLabel = "The button to add your ingredient."
        addIngredientButton.accessibilityHint = "Your ingredient will be displayed on the list."
        clearIngredientsButton.accessibilityLabel = "The button to clean your ingredient list."
        ingredientList.accessibilityLabel = "Your ingredient list."
    }
    
    private func deleteAllIngredients() {
        ingredientConfiguration.removeAllIngredients()
        ingredientList.reloadData()
    }
    
    private func addIngredient() {
        guard let ingredient = ingredientTextField.text, !ingredient.isEmpty else {
            presentAlert(with: "No ingredient to add, please provide one.")
            return
        }

        ingredientConfiguration.addIngredient(ingredient: ingredient)
        ingredientTextField.text = nil
        ingredientList.reloadData()
    }
    
    private func prepareSearchRecipes() {
        guard !ingredientConfiguration.ingredients.isEmpty else {
            presentAlert(with: "No ingredient in the list, please add one at least.")
            return
        }
                
        performSegue(withIdentifier: "segueToRecipes", sender: ingredientConfiguration)
    }
    
    @objc private func ingredientListControl() {
        if ingredientConfiguration.ingredients.isEmpty {
            noIngredientsLabel.isHidden = false
        } else {
            noIngredientsLabel.isHidden = true
        }
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
        return CGFloat(80)
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
