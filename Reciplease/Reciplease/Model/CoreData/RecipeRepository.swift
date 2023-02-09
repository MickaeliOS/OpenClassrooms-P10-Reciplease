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
        case deletionError
        
        var localizedDescription: String {
            switch self {
            case .savingError:
                return "We were unable to save your recipe."
            case .deletionError:
                return "We were unable to delete your recipe."
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
        
        recipeToSave.label = recipe.label
        recipeToSave.image = recipe.image
        recipeToSave.totalTime = recipe.totalTime
        recipeToSave.yield = recipe.yield
    
        // A Recipe can have multiples ingredients, so we need to save them
        ingredientRepository.addIngredients(ingredients: recipe.ingredients, recipe: recipeToSave, completion: { ingredients in
            recipeToSave.addToIngredients(ingredients)
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
    
    func deleteRecipe(recipe: Recipe) throws {
        coreDataStack.viewContext.delete(recipe)
        
        do {
            try coreDataStack.viewContext.save()
        } catch {
            print("We were unable to delete \(recipe)")
            throw RecipeError.deletionError
        }
    }
    
    func isFavorite(recipe: Recipe) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(,
        ]
    }
}
