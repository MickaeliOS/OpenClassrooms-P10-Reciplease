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
    
    enum IngredientsErrors: Error {
        case removeOneError
        case removeAllError
        
        var localizedDescription: String {
            switch self {
            case .removeAllError:
                return "Empty recipes list. Please add at least an ingredient."
            case .removeOneError:
                return "No ingredient to delete."
            }
        }
    }
    
    // MARK: - FUNCTIONS FOR RESEARCH
    func addIngredient(ingredient: String) {
        ingredients.append(ingredient)
        NotificationCenter.default.post(name: .ingredientsListModified, object: nil)
    }
    
    func removeIngredients(at index: Int) throws {
        guard ingredients.indices.contains(index) else {
            throw IngredientsErrors.removeOneError
        }
        
        ingredients.remove(at: index)
        NotificationCenter.default.post(name: .ingredientsListModified, object: nil)
    }
    
    func removeAllIngredients() throws {
        guard !ingredients.isEmpty else {
            throw IngredientsErrors.removeAllError
        }
        
        ingredients.removeAll()
        NotificationCenter.default.post(name: .ingredientsListModified, object: nil)
    }
    
    func formatIngredientsInOneLine(ingredientsFood: [IngredientAPI]) -> String {
        guard !ingredientsFood.isEmpty else {
            return ""
        }
        
        // We want to display the main ingredients in a single line
        return ingredientsFood.map { $0.food }.joined(separator: ", ")
    }
    
    func formatDetailledIngredientsInSeparateLines(ingredients: [IngredientAPI]) -> String {
        guard !ingredients.isEmpty else {
            return ""
        }
        
        // We want to display the detailled ingredients in separate lines
        let formattedIngredients = ingredients.map { "- \($0.text)\n" }
        return formattedIngredients.joined()
    }

    // MARK: - FUNCTIONS FOR FAVORITES
    func formatFavoriteIngredientsInOneLine(ingredients: NSOrderedSet) -> String {
        guard ingredients.count > 0 else {
            return ""
        }
        
        let ingredients = ingredients.map { ($0 as AnyObject).value(forKey: "food") as? String }.compactMap { $0 }
        return ingredients.joined(separator: ", ")
    }
    
    func formatFavoritesDetailledIngredientsInSeparateLines(ingredients: NSOrderedSet) -> String {
        guard ingredients.count > 0 else {
            return ""
        }
        
        let detailledIngredients = ingredients.map { ($0 as AnyObject).value(forKey: "text") as? String }.compactMap { $0 }
        var formattedIngredients = ""
        
        for instruction in detailledIngredients {
            formattedIngredients += "- \(instruction)\n"
        }
        return formattedIngredients
    }
}
