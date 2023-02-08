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
    
    /*func getImages(recipes: [RecipeInfos]) {
        recipeService.getImages(recipes: recipes) { recipesWithImages, apiCase in
            switch apiCase {
            case .error, .incorrectResponse:
                self.delegate?.getImagesDidFail()
            case .emptyImage:
                self.delegate?.getImagesDidFail()
            case .success:
                guard let recipesWithImages = recipesWithImages else {
                    return
                }
                self.delegate?.getImagesDidFinish(recipesWithImages)
            }
        }
    }*/
    
    /*func getImage(recipe: RecipeInfos) {
        recipeService.getImage(recipe: recipe) { imageData, apiCase in
            switch apiCase {
            case .error, .incorrectResponse:
                print("error or incorrect response")
                self.delegate?.getImageDidFail()
            case .emptyImage:
                print("empty image")
                self.delegate?.getImageDidFail()
            case .success:
                guard let imageData = imageData else {
                    return
                }
                self.delegate?.getImageDidFinish(imageData)
            }
        }
    }*/
}

protocol APICallCenterDelegate {
    func getRecipesDidFinish(_ result: [RecipeInfos])
    func getRecipesDidFail()
    /*func getImagesDidFinish(_ result: [RecipeInfos])
    func getImagesDidFail()*/
}
