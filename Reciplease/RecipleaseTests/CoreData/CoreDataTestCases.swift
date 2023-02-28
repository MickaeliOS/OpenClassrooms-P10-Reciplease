//
//  CoreDataTestCases.swift
//  RecipleaseTests
//
//  Created by Mickaël Horn on 24/02/2023.
//

import XCTest
@testable import Reciplease

final class CoreDataTestCases: XCTestCase {
    // MARK: - PROPERTIES
    let recipe1 = RecipeInfos(label: "label1",
                              image: "image1",
                              ingredients: [IngredientInfos(text: "text1", food: "food1"),
                                            IngredientInfos(text: "text2", food: "food2")],
                              url: "https://www.test1.com",
                              totalTime: 1.0)
    
    let recipe2 = RecipeInfos(label: "label2",
                              image: "image2",
                              ingredients: [IngredientInfos(text: "text3", food: "food3"),
                                            IngredientInfos(text: "text4", food: "food4")],
                              url: "https://www.test2.com",
                              totalTime: 2.0)
    
    var testCoreDataStack: TestCoreDataStack!
    var recipeRepository: RecipeRepository!

    // MARK: - OVERRIDE TEST FUNCTIONS
    override func setUp() {
        super.setUp()
        
        testCoreDataStack = TestCoreDataStack()
        recipeRepository = RecipeRepository(coreDataStackViewContext: testCoreDataStack.viewContext)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func addRecipes() {
        do {
            try recipeRepository.addRecipe(recipe: recipe1)
            try recipeRepository.addRecipe(recipe: recipe2)
        } catch {
            XCTFail()
        }
    }
    
    // MARK: - TESTS
    func testAddToRecipeShouldNotThrowIfRecipeAndIngredientsAreThere() {
        XCTAssertNoThrow(try recipeRepository.addRecipe(recipe: recipe1))
        
        recipeRepository.getRecipes { recipes in
            XCTAssertTrue(recipes.count == 1)
            
            let ingredient1 = recipes[0].ingredients?.firstObject as AnyObject
            let ingredient2 = recipes[0].ingredients?.lastObject as AnyObject
            
            XCTAssertEqual(recipes[0].label, recipe1.label)
            XCTAssertEqual(recipes[0].image, recipe1.image)
            XCTAssertEqual(recipes[0].url, recipe1.url)
            XCTAssertEqual(recipes[0].totalTime, recipe1.totalTime)
            XCTAssertEqual(ingredient1.text, recipe1.ingredients[0].text)
            XCTAssertEqual(ingredient1.food, recipe1.ingredients[0].food)
            XCTAssertEqual(ingredient2.text, recipe1.ingredients[1].text)
            XCTAssertEqual(ingredient2.food, recipe1.ingredients[1].food)
        }
    }
    
    func testGetRecipeReturnsTheRecipeIfItExists() {
        XCTAssertNoThrow(try recipeRepository.addRecipe(recipe: recipe1))

        recipeRepository.getRecipe(url: recipe1.url) { recipe in
            XCTAssertNotNil(recipe)
        }
    }
    
    func testGetRecipeReturnsNilIfRecipeDoesNotExists() {
        recipeRepository.getRecipe(url: recipe1.url) { recipe in
            XCTAssertNil(recipe)
        }
    }
        
    func testGetRecipesShouldSuccess() {
        // I'm adding 2 recipes for the test
        addRecipes()
        
        recipeRepository.getRecipes { recipes in
            XCTAssertTrue(recipes.count == 2)

            // Controls for the first recipe
            let ingredient1 = recipes[0].ingredients?.firstObject as AnyObject
            let ingredient2 = recipes[0].ingredients?.lastObject as AnyObject
            
            XCTAssertEqual(recipes[0].label, recipe1.label)
            XCTAssertEqual(recipes[0].image, recipe1.image)
            XCTAssertEqual(recipes[0].url, recipe1.url)
            XCTAssertEqual(recipes[0].totalTime, recipe1.totalTime)
            XCTAssertEqual(ingredient1.text, recipe1.ingredients[0].text)
            XCTAssertEqual(ingredient1.food, recipe1.ingredients[0].food)
            XCTAssertEqual(ingredient2.text, recipe1.ingredients[1].text)
            XCTAssertEqual(ingredient2.food, recipe1.ingredients[1].food)

            // Controls for the second recipe
            let ingredient3 = recipes[1].ingredients?.firstObject as AnyObject
            let ingredient4 = recipes[1].ingredients?.lastObject as AnyObject
            
            XCTAssertEqual(recipes[1].label, recipe2.label)
            XCTAssertEqual(recipes[1].image, recipe2.image)
            XCTAssertEqual(recipes[1].url, recipe2.url)
            XCTAssertEqual(recipes[1].totalTime, recipe2.totalTime)
            XCTAssertEqual(ingredient3.text, recipe2.ingredients[0].text)
            XCTAssertEqual(ingredient3.food, recipe2.ingredients[0].food)
            XCTAssertEqual(ingredient4.text, recipe2.ingredients[1].text)
            XCTAssertEqual(ingredient4.food, recipe2.ingredients[1].food)
        }
    }
    
    func testGetRecipesShouldReturnEmptyRecipesIfNoneExists() {
        recipeRepository.getRecipes { recipes in
            XCTAssertEqual(recipes, [])
        }
    }
    
    func testDeleteRecipeShouldNotThrowIfWeDeleteAnExistingRecipe() {
        var recipeToTest: Recipe?
        
        // First, we need to add a recipe to delete it later
        XCTAssertNoThrow(try recipeRepository.addRecipe(recipe: recipe1))
        
        // Then, we fetch the recipe to delete it
        recipeRepository.getRecipe(url: recipe1.url) { recipe in
            recipeToTest = recipe
            XCTAssertNotNil(recipeToTest)
        }
        
        // We delete it and if the deletion worked, there should be no recipe
        XCTAssertNoThrow(try recipeRepository.deleteRecipe(recipe: recipeToTest!))

        recipeRepository.getRecipe(url: recipe1.url) { recipe in
            XCTAssertNil(recipe)
        }
    }
    
    func testDeleteRecipeShouldNotThrowIfWeDeleteANonExistingRecipe() {
        XCTAssertNoThrow(try recipeRepository.deleteRecipe(recipe: Recipe()))
    }
    
    func testIsFavoriteReturnsTrueIfRecipeIsInFavorites() {
        XCTAssertNoThrow(try recipeRepository.addRecipe(recipe: recipe1))
        
        recipeRepository.isFavorite(recipe: recipe1) { isFavorite in
            XCTAssertTrue(isFavorite ?? false)
        }
    }
    
    func testIsFavoriteReturnsFalseIfRecipeIsNotInFavorites() {
        recipeRepository.isFavorite(recipe: recipe1) { isFavorite in
            XCTAssertFalse(isFavorite ?? true)
        }
    }
    
    func testCopyRecipeShouldSuccess() {
        XCTAssertNoThrow(try recipeRepository.addRecipe(recipe: recipe1))

        recipeRepository.getRecipes { recipes in
            guard let coreDataRecipe1 = recipes.first else {
                XCTFail()
                return
            }
            
            guard let copiedRecipe1 = recipeRepository.copyRecipe(recipe: coreDataRecipe1) else {
                XCTFail()
                return
            }

            XCTAssertEqual(recipes.count, 1)
            XCTAssertEqual(copiedRecipe1.label, recipe1.label)
            XCTAssertEqual(copiedRecipe1.image, recipe1.image)
            XCTAssertEqual(copiedRecipe1.url, recipe1.url)
            XCTAssertEqual(copiedRecipe1.totalTime, recipe1.totalTime)
            XCTAssertEqual(copiedRecipe1.ingredients[0].text, recipe1.ingredients[0].text)
            XCTAssertEqual(copiedRecipe1.ingredients[0].food, recipe1.ingredients[0].food)
            XCTAssertEqual(copiedRecipe1.ingredients[1].text, recipe1.ingredients[1].text)
            XCTAssertEqual(copiedRecipe1.ingredients[1].food, recipe1.ingredients[1].food)
        }
    }
    
    func testCopyRecipeShouldReturnNilIfOneOfOptionalParameterForRecipeIsNil() {
        XCTAssertNoThrow(try recipeRepository.addRecipe(recipe: recipe1))

        recipeRepository.getRecipes { recipes in
            guard let coreDataRecipe1 = recipes.first else {
                XCTFail()
                return
            }
            
            coreDataRecipe1.label = nil
            
            XCTAssertEqual(recipes.count, 1)
            XCTAssertNil(recipeRepository.copyRecipe(recipe: coreDataRecipe1))
        }
    }
}
