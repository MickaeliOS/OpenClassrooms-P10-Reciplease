//
//  RecipeRepository.swift
//  Reciplease
//
//  Created by Mickaël Horn on 03/02/2023.
//

import Foundation
import CoreData

class RecipeRepository {
    // MARK: - VARIABLES
    private let coreDataStack: CoreDataStack
    let ingredientRepository = IngredientRepository()
    
    // MARK: - ENUMS
    enum RecipeError: Error {
        case savingError
        
        var localizedDescription: String {
            switch self {
            case .savingError:
                return "We were unable to save your recipe."
            }
        }
    }

    // MARK: - INIT
    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
       self.coreDataStack = coreDataStack
    }
    
    // MARK: - FUNCTIONS
    func addToRecipe(recipe: RecipeInfos) throws {
        let recipeToSave = Recipe(context: coreDataStack.viewContext)
        
        recipeToSave.title = recipe.label
        recipeToSave.image = recipe.image
        recipeToSave.time = recipe.totalTime
        recipeToSave.score = recipe.yield
    
        // A Recipe can have multiples ingredients, so we need to save them
        ingredientRepository.addIngredients(recipe: recipe, completion: { ingredients in
            recipeToSave.ingredients = ingredients
        })
                
        do {
            try coreDataStack.viewContext.save()
        } catch {
            print("We were unable to save \(recipeToSave)")
            throw RecipeError.savingError
        }
    }
    
    func getRecipe(completion: ([Recipe]) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        do {
            let recipes = try coreDataStack.viewContext.fetch(request)
            completion(recipes)
        } catch {
            completion([])
        }
    }
}
