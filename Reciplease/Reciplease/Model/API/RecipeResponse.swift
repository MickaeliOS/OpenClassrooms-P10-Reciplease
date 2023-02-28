//
//  RecipeResponse.swift
//  Reciplease
//
//  Created by Mickaël Horn on 01/02/2023.
//

import Foundation

struct RecipeResponse: Decodable {
    let hits: [Hit]
    let links: Links
    
    private enum CodingKeys: String, CodingKey {
        // Even if i'm renaming 1 JSON key, i have to be exhaustive
        case links = "_links"
        case hits
    }
}

struct Hit: Decodable {
    let recipe: RecipeInfos
}

struct RecipeInfos: Decodable {
    let label: String
    let image: String
    let ingredients: [IngredientInfos]
    let url: String
    let totalTime: Double
}

struct IngredientInfos: Decodable {
    let text: String
    let food: String
}

struct Links: Decodable {
    let next: Next?
}

struct Next: Decodable {
    let href: String?
}
