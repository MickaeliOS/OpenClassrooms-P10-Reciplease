//
//  IngredientsViewController.swift
//  Reciplease
//
//  Created by Mickaël Horn on 01/02/2023.
//

// DM : 5C5C5C
// LM : 75
import UIKit

class IngredientsViewController: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VDL Triggered")
        setupInterface()
        setupVoiceOver()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ingredientListControl), name: .ingredientsListModified, object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // If we change the theme, we need to reload the ingredientTextField's border color
        ingredientTextField.addBottomBorder()
    }

    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var ingredientsListTitle: UINavigationItem!
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
    @IBOutlet weak var searchTabBarItem: UITabBarItem!
    
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
        // accessibilityLabel
        ingredientTextField.accessibilityLabel = "Put your ingredients here."
        addIngredientButton.accessibilityLabel = "Add your ingredient."
        clearIngredientsButton.accessibilityLabel = "Clear your ingredient list."
        ingredientList.accessibilityLabel = "Your ingredient list."

        // accessibilityValue
        ingredientTextField.accessibilityValue = "Example : lemon, cheese, sausage."

        // accessibilityHint
        addIngredientButton.accessibilityHint = "Your ingredient will be displayed on the list."
        searchRecipesButton.accessibilityHint = "Available recipes will be displayed."
    }
    
    private func deleteAllIngredients() {
        do {
            try ingredientConfiguration.removeAllIngredients()
            ingredientList.reloadData()
        } catch let error as IngredientConfiguration.IngredientsErrors {
            presentAlert(with: error.localizedDescription)
        } catch {
            presentAlert(with: "An error occurred.")
        }
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
            do {
                // Always remove the data first
                try ingredientConfiguration.removeIngredients(at: indexPath.row)
                
                // Then, the cell
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch let error as IngredientConfiguration.IngredientsErrors {
                presentAlert(with: error.localizedDescription)
            } catch {
                presentAlert(with: "An error occured.")
            }
        }
    }
}
