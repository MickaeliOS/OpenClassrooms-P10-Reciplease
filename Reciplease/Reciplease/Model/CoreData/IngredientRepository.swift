//
//  IngredientRepository.swift
//  Reciplease
//
//  Created by Mickaël Horn on 03/02/2023.
//

import Foundation
import CoreData

class IngredientRepository {
    // MARK: - FUNCTIONS
    func addIngredients(ingredients: [IngredientAPI], recipe: RecipeCD, viewContext: NSManagedObjectContext, completion: (NSOrderedSet) -> Void) {
        let ingredientsSet = NSMutableOrderedSet()
        
        ingredients.forEach { ingredient in
            let ingredientToSave = IngredientCD(context: viewContext)
            
            ingredientToSave.food = ingredient.food
            ingredientToSave.text = ingredient.text
            ingredientToSave.recipe = recipe
            
            ingredientsSet.add(ingredientToSave)
        }
                
        do {
            try viewContext.save()
            completion(ingredientsSet)
        } catch {
            print("Unable to save the ingredients.")
        }
    }
}
