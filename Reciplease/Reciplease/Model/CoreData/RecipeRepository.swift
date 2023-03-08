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
    private let coreDataStackViewContext: NSManagedObjectContext
    private let ingredientRepository = IngredientRepository()
    
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
    init(coreDataStackViewContext: NSManagedObjectContext = CoreDataStack.sharedInstance.viewContext) {
        self.coreDataStackViewContext = coreDataStackViewContext
    }
    
    // MARK: - FUNCTIONS
    func addRecipe(recipe: RecipeAPI) throws {
        let recipeToSave = RecipeCD(context: coreDataStackViewContext)
        
        recipeToSave.label = recipe.label
        recipeToSave.image = recipe.image
        recipeToSave.totalTime = recipe.totalTime
        recipeToSave.url = recipe.url
    
        // A Recipe can have multiples ingredients, so we need to save them
        ingredientRepository.addIngredients(ingredients: recipe.ingredients, recipe: recipeToSave, viewContext: coreDataStackViewContext, completion: { ingredients in
            recipeToSave.addToIngredients(ingredients)
        })
        
        do {
            try coreDataStackViewContext.save()
        } catch {
            throw RecipeError.savingError
        }
    }
    
    func getRecipe(url: String, completion: (RecipeCD?) -> Void) {
        let request: NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)

        coreDataStackViewContext.performAndWait {
            do {
                guard let recipe = try coreDataStackViewContext.fetch(request).first else {
                    completion(nil)
                    return
                }
                completion(recipe)
            } catch {
                print("An error occured.")
            }
        }
    }
    
    func getRecipes(completion: ([RecipeCD]) -> Void) {
        let request: NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()

        coreDataStackViewContext.performAndWait {
            do {
                let recipes = try coreDataStackViewContext.fetch(request)
                completion(recipes)
            } catch {
                print("We were unable to get the recipes.")
            }
        }
    }
    
    func deleteRecipe(recipe: RecipeCD) throws {
        try coreDataStackViewContext.performAndWait {
            do {
                coreDataStackViewContext.delete(recipe)
                try coreDataStackViewContext.save()
            } catch {
                print("We were unable to delete \(recipe)")
                throw RecipeError.deletionError
            }
        }
    }
    
    func isFavorite(recipe: RecipeAPI, completion : (Bool?) -> Void) {
        coreDataStackViewContext.performAndWait {
            let request : NSFetchRequest<RecipeCD> = RecipeCD.fetchRequest()
            request.predicate = NSPredicate(format: "url == %@", recipe.url)

            do {
                guard let _ = try coreDataStackViewContext.fetch(request).first else {
                    completion(false)
                    return
                }
                completion(true)
            } catch {
                print("An error occured.")
            }
        }
    }
    
    func copyRecipe(recipe: RecipeCD) -> RecipeAPI? {
            guard let label = recipe.label,
                  let image = recipe.image,
                  let url = recipe.url,
                  let ingredientsOrderedSet = recipe.ingredients else {
                return nil
            }

            var ingredients = [IngredientAPI]()
            
            ingredientsOrderedSet.forEach { element in
                ingredients.append(IngredientAPI(text: (element as AnyObject).text ?? "", food: (element as AnyObject).food ?? ""))
            }

            let recipeInfos = RecipeAPI(label: label, image: image, ingredients: ingredients, url: url, totalTime: recipe.totalTime)
            
            return recipeInfos
        }
}
