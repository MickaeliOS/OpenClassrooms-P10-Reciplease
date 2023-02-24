//
//  CoreDataTestCases.swift
//  RecipleaseTests
//
//  Created by Mickaël Horn on 24/02/2023.
//

import XCTest
@testable import Reciplease

final class CoreDataTestCases: XCTestCase {
    let recipe1 = RecipeInfos(label: "label1",
                              image: "image1",
                              ingredients: [IngredientInfos(text: "text1", food: "food1"),
                                            IngredientInfos(text: "text2", food: "food2")],
                              yield: 1.0,
                              url: "https://www.test1.com",
                              totalTime: 1.0)
    
    let recipe2 = RecipeInfos(label: "label2",
                              image: "image2",
                              ingredients: [IngredientInfos(text: "text3", food: "food3"),
                                            IngredientInfos(text: "text4", food: "food4")],
                              yield: 2.0,
                              url: "https://www.test2.com",
                              totalTime: 2.0)
    
    var testCoreDataStack: TestCoreDataStack!
    var recipeRepository: RecipeRepository!

    override func setUp() {
        super.setUp()
        
        testCoreDataStack = TestCoreDataStack()
        recipeRepository = RecipeRepository(coreDataStackViewContext: testCoreDataStack.viewContext)
    }
    
    private func addRecipes() {
        do {
            try recipeRepository.addToRecipe(recipe: recipe1)
            try recipeRepository.addToRecipe(recipe: recipe2)
        } catch {
            XCTFail()
        }
    }
    
    func testAddToRecipeShouldNotThrowIfRecipeAndIngredientsAreThere() {
        XCTAssertNoThrow(try recipeRepository.addToRecipe(recipe: recipe1))
        
        recipeRepository.getRecipes { recipes in
            XCTAssertTrue(recipes.count == 1)
            
            let ingredient1 = recipes[0].ingredients?.firstObject as AnyObject
            let ingredient2 = recipes[0].ingredients?.lastObject as AnyObject
            
            XCTAssertEqual(recipes[0].label, recipe1.label)
            XCTAssertEqual(recipes[0].image, recipe1.image)
            XCTAssertEqual(recipes[0].yield, recipe1.yield)
            XCTAssertEqual(recipes[0].url, recipe1.url)
            XCTAssertEqual(recipes[0].totalTime, recipe1.totalTime)
            XCTAssertEqual(ingredient1.text, recipe1.ingredients[0].text)
            XCTAssertEqual(ingredient1.food, recipe1.ingredients[0].food)
            XCTAssertEqual(ingredient2.text, recipe1.ingredients[1].text)
            XCTAssertEqual(ingredient2.food, recipe1.ingredients[1].food)
        }
    }
    
    func testAddRecipeShouldThrowIfSavingError() {
        //TODO
    }
    
    func testGetRecipeReturnsTheRecipeIfItExists() {
        XCTAssertNoThrow(try recipeRepository.addToRecipe(recipe: recipe1))

        recipeRepository.getRecipe(url: recipe1.url) { recipe in
            XCTAssertNotNil(recipe)
        }
    }
    
    func testGetRecipeReturnsNilIfRecipeDoesNotExists() {
        recipeRepository.getRecipe(url: recipe1.url) { recipe in
            XCTAssertNil(recipe)
        }
    }
    
    func testGetRecipeShouldThrowIfFetchError() {
        //TODO
    }
        
    func testGetRecipesShouldSuccess() {
        // I'm adding 2 recipes for the test
        addRecipes()
        
        recipeRepository.getRecipes { recipes in
            XCTAssertTrue(recipes.count == 2)

            // Controls for the first recipe
            let ingredient1 = recipes[0].ingredients?.firstObject as AnyObject
            let ingredient2 = recipes[0].ingredients?.lastObject as AnyObject
            
            XCTAssertEqual(recipes[0].label, "label1")
            XCTAssertEqual(recipes[0].image, "image1")
            XCTAssertEqual(recipes[0].yield, 1.0)
            XCTAssertEqual(recipes[0].url, "https://www.test1.com")
            XCTAssertEqual(recipes[0].totalTime, 1.0)
            XCTAssertEqual(ingredient1.text, "text1")
            XCTAssertEqual(ingredient1.food, "food1")
            XCTAssertEqual(ingredient2.text, "text2")
            XCTAssertEqual(ingredient2.food, "food2")

            // Controls for the second recipe
            let ingredient3 = recipes[1].ingredients?.firstObject as AnyObject
            let ingredient4 = recipes[1].ingredients?.lastObject as AnyObject
            
            XCTAssertEqual(recipes[1].label, "label2")
            XCTAssertEqual(recipes[1].image, "image2")
            XCTAssertEqual(recipes[1].yield, 2.0)
            XCTAssertEqual(recipes[1].url, "https://www.test2.com")
            XCTAssertEqual(recipes[1].totalTime, 2.0)
            XCTAssertEqual(ingredient3.text, "text3")
            XCTAssertEqual(ingredient3.food, "food3")
            XCTAssertEqual(ingredient4.text, "text4")
            XCTAssertEqual(ingredient4.food, "food4")
        }
    }
    
    func testGetRecipesShouldReturnEmptyRecipesIfNoneExists() {
        recipeRepository.getRecipes { recipes in
            XCTAssertEqual(recipes, [])
        }
    }
    
    func testGetRecipesShouldThrowIfFetchError() {
        //TODO
    }
    
    func testDeleteRecipeShouldNotThrowIfWeDeleteAnExistingRecipe() {
        var recipeToTest: Recipe?
        
        // First, we need to add a recipe to delete it later
        XCTAssertNoThrow(try recipeRepository.addToRecipe(recipe: recipe1))
        
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
    
    func testDeleteRecipeShouldThrowIfSavingError() {
        //TODO
    }
    
    // First isFavorite function
    func testIsFavoriteFromURLReturnsTrueIfRecipeIsInFavorites() {
        //TODO
    }
    
    func testIsFavoriteFromURLReturnsFalseIfRecipeIsNotInFavorites() {
        //TODO
    }
    
    func testIsFavoriteFromURLShouldThrowIfFetchError() {
        //TODO
    }
    
    // Second isFavorite function
    func testIsFavoriteFromRecipeInfosReturnsTrueIfRecipeIsInFavorites() {
        //TODO
    }
    
    func testIsFavoriteFromRecipeInfosReturnsFalseIfRecipeIsNotInFavorites() {
        //TODO
    }
    
    func testIsFavoriteFromRecipeInfosShouldThrowIfFetchError() {
        //TODO
    }
    
    func testCopyRecipeShouldSuccess() {
        //TODO
    }
    
    func testCopyRecipeShouldReturnNilIfOneOfOptionalParameterForRecipeIsNil() {
        //TODO
    }
}
