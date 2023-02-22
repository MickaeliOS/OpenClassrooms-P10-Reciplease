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
            case .error:
                self.delegate?.getRecipesDidFailWithError()
                return
            case .incorrectResponse:
                self.delegate?.getRecipesDidFailWithIncorrectResponse()
                return
            case .success:
                self.delegate?.getRecipesDidFinish(result: recipes, nextPage: nextPage)
            }
        }
    }
    
    func getNextPage(nextPage: Next) {
        recipeService.getNextPage(nextPage: nextPage) { recipes, nextPage, apiCase in
            switch apiCase {
            case .error:
                self.delegate?.getNextPageDidFailWithError()
                return
            case .incorrectResponse:
                self.delegate?.getNextPageDidFailWithIncorrectResponse()
                return
            case .success:
                self.delegate?.getNextPageDidFinish(result: recipes, nextPage: nextPage)
            }
        }
    }
}

protocol APICallCenterDelegate {
    func getRecipesDidFinish(result: [RecipeInfos]?, nextPage: Next?)
    func getRecipesDidFailWithError()
    func getRecipesDidFailWithIncorrectResponse()
    
    func getNextPageDidFinish(result: [RecipeInfos]?, nextPage: Next?)
    func getNextPageDidFailWithError()
    func getNextPageDidFailWithIncorrectResponse()
}
