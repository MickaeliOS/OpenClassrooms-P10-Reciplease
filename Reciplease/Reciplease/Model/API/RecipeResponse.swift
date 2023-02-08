//
//  RecipeResponse.swift
//  Reciplease
//
//  Created by Mickaël Horn on 01/02/2023.
//

import Foundation

struct RecipeResponse: Decodable {
    let hits: [Hit]
}

struct Hit: Decodable {
    let recipe: RecipeInfos
}

struct RecipeInfos: Decodable {
    let label: String
    let image: String
    let ingredients: [IngredientInfos]
    let yield: Double
    let totalTime: Double
}

struct IngredientInfos: Decodable {
    let text: String
    let food: String
}
