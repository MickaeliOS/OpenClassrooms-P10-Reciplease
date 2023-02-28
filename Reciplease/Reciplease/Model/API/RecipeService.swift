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
    // MARK: - PROPERTIES & ENUMS
    private let manager: Session
    var recipes = [RecipeInfos]()
    
    enum APICases {
        case error
        case incorrectResponse
        case success
        case empty
    }
    
    // MARK: - INIT
    init(manager: Session) {
        self.manager = manager
    }
    
    // MARK: - FUNCTIONS
    func searchRecipes(with ingredients: String, nbIngredients: String, callback: @escaping ([RecipeInfos]?, Next?, APICases) -> Void) {
        let parameters = ["q": ingredients, "ingr": nbIngredients, "app_id": APIConfiguration.shared.appID, "app_key": APIConfiguration.shared.apiKey]
        
        manager.request(APIConfiguration.shared.baseURL, method: .get, parameters: parameters).responseDecodable(of: RecipeResponse.self) { [self] response in
            guard response.error == nil else {
                callback(nil, nil, .error)
                return
            }
            
            guard let data = response.value, !data.hits.isEmpty else {
                callback(nil, nil, .empty)
                return
            }
            
            guard let urlResponse = response.response, urlResponse.statusCode == 200 else {
                callback(nil, nil, .incorrectResponse)
                return
            }
            
            data.hits.forEach { hit in
                let recipe = RecipeInfos(label: hit.recipe.label,
                                         image: hit.recipe.image,
                                         ingredients: hit.recipe.ingredients,
                                         url: hit.recipe.url,
                                         totalTime: hit.recipe.totalTime)
                
                recipes.append(recipe)
                
            }
            callback(recipes, data.links.next, .success)
        }
    }
    
    func getNextPage(nextPage: Next, callback: @escaping ([RecipeInfos]?, Next?, APICases) -> Void) {
        guard let url = nextPage.href else { return }
        
        manager.request(URL(string: url)!, method: .get).responseDecodable(of: RecipeResponse.self) { [self] response in
            guard response.error == nil else {
                callback(nil, nil, .error)
                return
            }
            
            guard let data = response.value, !data.hits.isEmpty else {
                callback(nil, nil, .empty)
                return
            }
            
            guard let urlResponse = response.response, urlResponse.statusCode == 200 else {
                callback(nil, nil, .incorrectResponse)
                return
            }
            
            data.hits.forEach { hit in
                let recipe = RecipeInfos(label: hit.recipe.label,
                                         image: hit.recipe.image,
                                         ingredients: hit.recipe.ingredients,
                                         url: hit.recipe.url,
                                         totalTime: hit.recipe.totalTime)
                
                recipes.append(recipe)
            }
            
            callback(recipes, data.links.next, .success)
        }
    }
}
