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
        recipeService.searchRecipes(with: ingredients, nbIngredients: nbIngredients) { recipes, nextPage, apiCase in
            switch apiCase {
            case .error, .incorrectResponse:
                self.delegate?.getRecipesDidFail()
                return
            case .emptyRecipes:
                self.delegate?.getRecipesDidFinish(result: nil, nextPage: nil)
                return
            case .success:
                guard let recipes = recipes else {
                    return
                }
                self.delegate?.getRecipesDidFinish(result: recipes, nextPage: nextPage)
            }
        }
    }
    
    func getNextPage(nextPage: Next) {
        recipeService.getNextPage(nextPage: nextPage) { recipes, nextPage, apiCase in
            switch apiCase {
            case .error, .incorrectResponse:
                self.delegate?.getRecipesDidFail()
                return
            case .emptyRecipes:
                self.delegate?.getRecipesDidFinish(result: nil, nextPage: nil)
                return
            case .success:
                guard let recipes = recipes else {
                    return
                }
                self.delegate?.getRecipesDidFinish(result: recipes, nextPage: nextPage)
            }
        }
    }
}

protocol APICallCenterDelegate {
    func getRecipesDidFinish(result: [RecipeInfos]?, nextPage: Next?)
    func getRecipesDidFail()
}
