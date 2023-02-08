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
    
    enum IngredientError: Error {
        case noIngredient
        
        var localizedDescription: String {
            switch self {
            case .noIngredient:
                return "Please fill an ingredient."
            }
        }
    }
    
    // MARK: - FUNCTIONS
    func addIngredient(ingredient: String?) throws {
        guard let ingredient = ingredient else {
            throw IngredientError.noIngredient
        }
        ingredients.append(ingredient)
    }
    
    func removeIngredients(at index: Int) {
        ingredients.remove(at: index)
    }
    
    func removeAllIngredients() {
        ingredients.removeAll()
    }
    
    func formatIngredientsForAPIRequest(ingredients: [String]) -> String {
        // The API Request needs a String format for the ingredients
        // so we transform our String Array to a String
        var ingredientsString = ""
        
        ingredients.forEach { ingredient in
            ingredientsString += "\(ingredient)\n"
        }
        
        return ingredientsString
    }
    
    func formatMainIngredientsInOneLine(ingredientsFood: [IngredientInfos]) -> String {
        // We want to display the main ingredients in a single line
        var ingredientsString = ""

        ingredientsFood.forEach { ingredientInfo in
            ingredientsString += "\(ingredientInfo.food), "
        }
        
        return ingredientsString
    }
    
    func formatDetailedIngredients(ingredients: [IngredientInfos]) -> String {
        // We need each ingredient's details in one line, then we break a line
        var ingredientsString = ""

        ingredients.forEach { ingredient in
            ingredientsString += "- \(ingredient.text)\n"
        }
        
        return ingredientsString
    }
}
