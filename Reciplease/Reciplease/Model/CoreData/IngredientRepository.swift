//
//  IngredientRepository.swift
//  Reciplease
//
//  Created by Mickaël Horn on 03/02/2023.
//

import Foundation
import CoreData

class IngredientRepository {
    // MARK: - VARIABLES
    private let coreDataStack: CoreDataStack

    // MARK: - INIT
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
       self.coreDataStack = coreDataStack
    }
    
    // MARK: - FUNCTIONS
    func addIngredients(ingredients: [IngredientInfos], recipe: Recipe, completion: (NSOrderedSet) -> Void) {
        let ingredientsSet = NSMutableOrderedSet()
        
        ingredients.forEach { ingredient in
            let ingredientToSave = Ingredient(context: coreDataStack.viewContext)
            
            ingredientToSave.food = ingredient.food
            ingredientToSave.text = ingredient.text
            ingredientToSave.recipe = recipe
            
            ingredientsSet.add(ingredientToSave)
        }
                
        do {
            try coreDataStack.viewContext.save()
            completion(ingredientsSet)
        } catch {
            print("Unable to save the ingredients.")
        }
    }
}
