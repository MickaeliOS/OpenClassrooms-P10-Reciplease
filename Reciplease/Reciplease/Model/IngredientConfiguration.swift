//
//  IngredientConfiguration.swift
//  Reciplease
//
//  Created by Mickaël Horn on 01/02/2023.
//

import Foundation

class IngredientConfiguration {
    // MARK: - VARIABLES & ENUM
    var ingredients: [String] = []
    
    // MARK: - FUNCTIONS FOR RESEARCH
    func addIngredient(ingredient: String) {
        ingredients.append(ingredient)
    }
    
    func removeIngredients(at index: Int) {
        ingredients.remove(at: index)
    }
    
    func removeAllIngredients() {
        ingredients.removeAll()
    }
    
    func formatIngredientsInOneLine(ingredientsFood: [IngredientInfos]) -> String {
        // We want to display the main ingredients in a single line
        return ingredientsFood.map { $0.food }.joined(separator: ", ")
    }
    
    func formatInstructions(ingredients: [IngredientInfos]) -> String {
        // We want to display the instructions in separate lines
        let formattedIngredients = ingredients.map { "- \($0.text)\n" }
        return formattedIngredients.joined()
    }

    
    // MARK: - FUNCTIONS FOR FAVORITES
    func formatFavoriteIngredientsInOneLine(ingredientsFood: NSSet) -> String {
        let ingredients = ingredientsFood.map { ($0 as AnyObject).value(forKey: "food") as? String }.compactMap { $0 }
        return ingredients.joined(separator: ", ")
    }
}
