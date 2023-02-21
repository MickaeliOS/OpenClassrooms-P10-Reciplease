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
    private let manager: Session
    init(manager: Session) {
        self.manager = manager
    }
    
    // MARK: - VARIABLES
    var recipes = [RecipeInfos]()
    
    enum SearchAPICases {
        case error
        case incorrectResponse
        case emptyRecipes
        case success
    }
    
    // MARK: - FUNCTIONS
    func searchRecipes(with ingredients: String, nbIngredients: String, callback: @escaping ([RecipeInfos]?, Next?, SearchAPICases) -> Void) {
        let parameters = ["q": ingredients, "ingr": "10", "app_id": APIConfiguration.shared.appID, "app_key": APIConfiguration.shared.apiKey]
        
        manager.request(APIConfiguration.shared.baseURL, method: .get, parameters: parameters).responseDecodable(of: RecipeResponse.self) { [self] response in
            guard let data = response.value, response.error == nil else {
                callback(nil, nil, SearchAPICases.error)
                return
            }
            
            guard let urlResponse = response.response, urlResponse.statusCode == 200 else {
                callback(nil, nil, SearchAPICases.incorrectResponse)
                return
            }
            
            if data.hits.count == 0 {
                callback(nil, nil, SearchAPICases.emptyRecipes)
                return
            }
            
            data.hits.forEach { hit in
                let recipe = RecipeInfos(label: hit.recipe.label,
                                         image: hit.recipe.image,
                                         ingredients: hit.recipe.ingredients,
                                         yield: hit.recipe.yield,
                                         url: hit.recipe.url,
                                         totalTime: hit.recipe.totalTime)
                
                recipes.append(recipe)
                
            }
            print("MKA - Nombre de recettes : \(data.hits.count)")
            callback(recipes, data.links.next, SearchAPICases.success)
        }
    }
    
    func getNextPage(nextPage: Next, callback: @escaping ([RecipeInfos]?, Next?, SearchAPICases) -> Void) {
        guard let url = nextPage.href else { return }
        
        manager.request(URL(string: url)!, method: .get).responseDecodable(of: RecipeResponse.self) { [self] response in
            guard let data = response.value, response.error == nil else {
                callback(nil, nil, SearchAPICases.error)
                return
            }
            
            guard let urlResponse = response.response, urlResponse.statusCode == 200 else {
                callback(nil, nil, SearchAPICases.incorrectResponse)
                return
            }
            
            if data.hits.count == 0 {
                callback(nil, nil, SearchAPICases.emptyRecipes)
                return
            }
            
            data.hits.forEach { hit in
                let recipe = RecipeInfos(label: hit.recipe.label,
                                         image: hit.recipe.image,
                                         ingredients: hit.recipe.ingredients,
                                         yield: hit.recipe.yield,
                                         url: hit.recipe.url,
                                         totalTime: hit.recipe.totalTime)
                
                recipes.append(recipe)
            }
            
            print("MKA - Nombre de recettes : \(data.hits.count)")
            callback(recipes, data.links.next, SearchAPICases.success)
        }
    }
}
