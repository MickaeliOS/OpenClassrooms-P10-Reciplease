//
//  APICallCenter.swift
//  Reciplease
//
//  Created by Mickaël Horn on 06/02/2023.
//

import Foundation
import Alamofire

class APICallCenter {
    var delegate: APICallCenterDelegate?
    var recipeService: RecipeService
    
    init(manager: Session = Session.default) {
        recipeService = RecipeService(manager: manager)
    }
    
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
                self.delegate?.getNextPageDidFail()
                return
            case .emptyRecipes:
                self.delegate?.getNextPageDidFinish(result: nil, nextPage: nil)
                return
            case .success:
                guard let recipes = recipes else {
                    return
                }
                self.delegate?.getNextPageDidFinish(result: recipes, nextPage: nextPage)
            }
        }
    }
}

protocol APICallCenterDelegate {
    func getRecipesDidFinish(result: [RecipeInfos]?, nextPage: Next?)
    func getRecipesDidFail()
    func getNextPageDidFinish(result: [RecipeInfos]?, nextPage: Next?)
    func getNextPageDidFail()
}
