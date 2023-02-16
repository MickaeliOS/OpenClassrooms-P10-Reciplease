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
        case getError
        
        var localizedDescription: String {
            switch self {
            case .savingError:
                return "We were unable to save your recipe."
            case .deletionError:
                return "We were unable to delete your recipe."
            case .getError:
                return ""
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
        recipeToSave.url = recipe.url
    
        // A Recipe can have multiples ingredients, so we need to save them
        ingredientRepository.addIngredients(ingredients: recipe.ingredients, recipe: recipeToSave, completion: { ingredients in
            recipeToSave.addToIngredients(ingredients)
        })
                
        do {
            try coreDataStack.viewContext.save()
        } catch {
            throw RecipeError.savingError
        }
    }
    
    func getRecipes(completion: ([Recipe]) -> Void) {
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
    
    /*func deleteRecipe(recipeInfos: RecipeInfos) throws {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "image == %@", recipeInfos.image)
        request.predicate = NSPredicate(format: "label == %@", recipeInfos.label)
        request.predicate = NSPredicate(format: "totalTime == %@", recipeInfos.totalTime)
        request.predicate = NSPredicate(format: "url == %@", recipeInfos.url)
        request.predicate = NSPredicate(format: "yield == %@", recipeInfos.yield)

        let ingredients = ingredientRepository.getIngredientsFromRecipe(recipe: <#T##Recipe#>, completion: <#T##([Ingredient]) -> Void#>)
        


        coreDataStack.viewContext.delete(recipeInfos)
        
        do {
            try coreDataStack.viewContext.save()
        } catch {
            print("We were unable to delete \(recipe)")
            throw RecipeError.deletionError
        }
    }*/
}
