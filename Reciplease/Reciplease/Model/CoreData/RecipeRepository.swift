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
    
    func addToRecipe(recipe: Recipe) throws {
        var recipeToSave = Recipe(context: coreDataStack.viewContext)
        recipeToSave = recipe

        do {
            try coreDataStack.viewContext.save()
        } catch {
            print("We were unable to save \(recipeToSave)")
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
    
    func isFavorite(url: String, completion: (Bool?) -> Void) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)

        do {
            guard let _ = try coreDataStack.viewContext.fetch(request).first else {
                completion(false)
                return
            }
            completion(true)
        } catch {
            print("An error occured.")
        }
    }
    
    func isFavorite(recipe: RecipeInfos, completion : (Bool?) -> Void) {
        let request : NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", recipe.url)

        do {            
            guard let _ = try coreDataStack.viewContext.fetch(request).first else {
                completion(false)
                return
            }
            completion(true)
        } catch {
            print("An error occured.")
        }
    }
    
    /*func deleteRecipe(recipeInfos: RecipeInfos) throws {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        let ingredientsSet = NSSet(array: recipeInfos.ingredients)
        request.predicate = NSPredicate(format: "ingredients == %@", ingredientsSet)
   
        do {
            //TODO: Mettre la contrainte sur les ingrédients et afficher en commentaire : Since "ingredients" is a unique contraint, i'm sure the result will only have 1 result
            let recipe = try coreDataStack.viewContext.fetch(request).first
            
            guard let recipe = recipe else {
                print("Unable to delete the recipe")
                throw RecipeError.deletionError
            }
            
            try deleteRecipe(recipe: recipe)

        } catch {
            print("Unable to delete \(recipeInfos)")
            throw RecipeError.deletionError
        }
    }*/
}
