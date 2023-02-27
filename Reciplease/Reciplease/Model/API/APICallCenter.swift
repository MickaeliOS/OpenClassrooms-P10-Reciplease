//
//  APICallCenter.swift
//  Reciplease
//
//  Created by Mickaël Horn on 06/02/2023.
//

import Foundation
import Alamofire

class APICallCenter {
    // MARK: - PROPERTIES
    var delegate: APICallCenterDelegate?
    var recipeService: RecipeService
    
    // MARK: - INIT
    init(manager: Session = Session.default) {
        recipeService = RecipeService(manager: manager)
    }
    
    // MARK: - FUNCTIONS
    func getRecipes(ingredients: String, nbIngredients: String) {
        recipeService.searchRecipes(with: ingredients, nbIngredients: nbIngredients) { recipes, nextPage, apiCase in
            switch apiCase {
            case .success:
                guard let recipes = recipes else { return }
                self.delegate?.getRecipesDidFinish(recipes: recipes, nextPage: nextPage)
            case .error:
                self.delegate?.getRecipesDidFailWithError()
                return
            case .incorrectResponse:
                self.delegate?.getRecipesDidFailWithIncorrectResponse()
                return
            case .empty:
                self.delegate?.getRecipesDidFailWithEmptyRecipes()
                return
            }
        }
    }
    
    func getNextPage(nextPage: Next) {
        recipeService.getNextPage(nextPage: nextPage) { recipes, nextPage, apiCase in
            switch apiCase {
            case .success:
                guard let recipes = recipes else { return }
                self.delegate?.getNextPageDidFinish(recipes: recipes, nextPage: nextPage)
            case .error:
                self.delegate?.getNextPageDidFailWithError()
                return
            case .incorrectResponse:
                self.delegate?.getNextPageDidFailWithIncorrectResponse()
                return
            case .empty:
                self.delegate?.getNextPageDidFailWithEmptyRecipes()
                return
            }
        }
    }
}

// MARK: - DELEGATE
protocol APICallCenterDelegate {
    func getRecipesDidFinish(recipes: [RecipeInfos], nextPage: Next?)
    func getRecipesDidFailWithError()
    func getRecipesDidFailWithIncorrectResponse()
    func getRecipesDidFailWithEmptyRecipes()
    
    func getNextPageDidFinish(recipes: [RecipeInfos], nextPage: Next?)
    func getNextPageDidFailWithError()
    func getNextPageDidFailWithIncorrectResponse()
    func getNextPageDidFailWithEmptyRecipes()
}
