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
    func addIngredients(ingredients: [IngredientInfos], recipe: Recipe, completion: (NSSet) -> Void) {
        let ingredientsSet = NSSet()
        
        ingredients.forEach { ingredient in
            let ingredientToSave = Ingredient(context: coreDataStack.viewContext)
            
            ingredientToSave.food = ingredient.food
            ingredientToSave.text = ingredient.text
            ingredientToSave.recipe = recipe
            
            ingredientsSet.adding(ingredientToSave)
        }
                
        do {
            try coreDataStack.viewContext.save()
            completion(ingredientsSet)
        } catch {
            print("We were unable to save the ingredients.")
        }
    }
}
