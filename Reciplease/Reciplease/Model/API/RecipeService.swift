//
//  RecipeService.swift
//  Reciplease
//
//  Created by Mickaël Horn on 01/02/2023.
//

import Foundation
import Alamofire
import CoreData

class RecipeService {
    // MARK: - VARIABLES
    var recipes = [RecipeInfos]()
    
    enum SearchAPICases {
        case error
        case incorrectResponse
        case emptyRecipes
        case success
    }
    
    enum ImagesAPICases {
        case error
        case incorrectResponse
        case emptyImage
        case success
    }
    
    // MARK: - FUNCTIONS
    func searchRecipes(with ingredients: String, nbIngredients: String, callback: @escaping ([RecipeInfos]?, SearchAPICases) -> Void) {
        let parameters = ["q": ingredients, "ingr": nbIngredients, "app_id": APIConfiguration.shared.appID, "app_key": APIConfiguration.shared.apiKey]
        
        AF.request(APIConfiguration.shared.baseURL, method: .get, parameters: parameters).responseDecodable(of: RecipeResponse.self) { [self] response in
            guard let data = response.value, response.error == nil else {
                callback(nil, SearchAPICases.error)
                return
            }
            
            guard let urlResponse = response.response, urlResponse.statusCode == 200 else {
                callback(nil, SearchAPICases.incorrectResponse)
                return
            }
            
            if data.hits.count == 0 {
                callback(nil, SearchAPICases.emptyRecipes)
                return
            }
            
            data.hits.forEach { hit in
                let recipe = RecipeInfos(label: hit.recipe.label,
                                         image: hit.recipe.image,
                                         ingredients: hit.recipe.ingredients,
                                         yield: hit.recipe.yield,
                                         totalTime: hit.recipe.totalTime)
                
                recipes.append(recipe)
                
            }
            callback(recipes, SearchAPICases.success) // Ca ne marche peut-être pas ici
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    /*func getImage(image: String, callback: @escaping (Bool, Data?, Error?) -> Void) {
        AF.request(image).responseData { result in
            guard let urlResponse = result.response, urlResponse.statusCode == 200 else {
                callback(false, nil, nil)
                return
            }
            
            guard let data = result.data, result.error == nil else {
                callback(false, nil, result.error)
                return
            }
            
            callback(true, data, nil)
        }
    }*/
    
    // Fonction implémentant le champ imageData de la structure
    /*func getImages(recipes: [RecipeInfos], callback: @escaping ([RecipeInfos]?, ImagesAPICases) -> Void) {
        //TODO: Gérer les autres cas (error, incorrectResponse, emptyImage)
        var count = 0
        
        for (index, recipe) in recipes.enumerated() {
            AF.request(recipe.image).responseData { result in
                guard let urlResponse = result.response, urlResponse.statusCode == 200 else {
                    return
                }
                
                guard let data = result.data, result.error == nil else {
                    return
                }
                
                self.recipes[index].imageData = data

                count += 1
                if count == recipes.count {
                    callback(self.recipes, .success)
                }
            }
        }
    }*/
    
    // Fonction retournant un tableau de Data
    /*func getImages(recipes: [RecipeInfos], callback: @escaping ([Data]?, ImagesAPICases) -> Void) {
        var imagesDatas: [Data] = []
        var count = 0
        
        recipes.forEach { recipe in
            AF.request(recipe.image).responseData { result in
                guard let data = result.data, result.error == nil else {
                    callback(nil, .error)
                    return
                }
                
                guard let urlResponse = result.response, urlResponse.statusCode == 200 else {
                    callback(nil, .incorrectResponse)
                    return
                }
            
                imagesDatas.append(data)
                count += 1
                if count == recipes.count {
                    callback(imagesDatas, .success)
                }
            }
            //recipes[index].imageData = result
        }
    }*/
    
    /*func getImage(recipe: RecipeInfos, callback: @escaping (Data?, ImagesAPICases) -> Void) {
        AF.request(recipe.image).responseData { result in
            guard let urlResponse = result.response, urlResponse.statusCode == 200 else {
                return
            }
            
            guard let data = result.data, result.error == nil else {
                return
            }
            
            callback(data, ImagesAPICases.success)
        }
    }*/
}
