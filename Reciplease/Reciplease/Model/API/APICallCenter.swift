//
//  APICallCenter.swift
//  Reciplease
//
//  Created by Mickaël Horn on 06/02/2023.
//

import Foundation

class APICallCenter {
    var delegate: APICallCenterDelegate?
    let recipeService = RecipeService()

    func getRecipes(ingredients: String, nbIngredients: String) {
        recipeService.searchRecipes(with: ingredients, nbIngredients: nbIngredients) { recipes, apiCase in
            switch apiCase {
            case .error, .incorrectResponse:
                self.delegate?.getRecipesDidFail()
                return
            case .emptyRecipes:
                self.delegate?.getRecipesDidFinish([])
                return
            case .success:
                guard let recipes = recipes else {
                    return
                }
                self.delegate?.getRecipesDidFinish(recipes)
            }
        }
    }
}

protocol APICallCenterDelegate {
    func getRecipesDidFinish(_ result: [RecipeInfos])
    func getRecipesDidFail()
}
