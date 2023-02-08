//
//  IngredientRepository.swift
//  Reciplease
//
//  Created by Mickaël Horn on 03/02/2023.
//

import Foundation

class IngredientRepository {
    // MARK: - VARIABLES
    private let coreDataStack: CoreDataStack

    // MARK: - INIT
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
       self.coreDataStack = coreDataStack
    }
    
    // MARK: - FUNCTIONS
    func addIngredients(recipe: RecipeInfos, completion: (NSSet) -> Void) {
        var ingredients = NSSet()
        
        recipe.ingredients.forEach { ingredient in
            let ingredientToSave = Ingredient(context: coreDataStack.viewContext)
            ingredientToSave.food = ingredient.food
            ingredientToSave.detail = ingredient.text
            ingredients.adding(ingredient)
        }
        
        do {
            try coreDataStack.viewContext.save()
            completion(ingredients)
        } catch {
            print("We were unable to save the ingredients.")
        }
    }
}
