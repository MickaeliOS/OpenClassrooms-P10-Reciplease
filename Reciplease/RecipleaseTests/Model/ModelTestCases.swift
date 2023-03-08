//
//  ModelTestCases.swift
//  RecipleaseTests
//
//  Created by Mickaël Horn on 22/02/2023.
//

import XCTest
import Alamofire
@testable import Reciplease

final class ModelTestCases: XCTestCase {
    // MARK: - PROPERTIES
    private var ingredientConfiguration: IngredientConfiguration!
    private var ingredientsOrderedSet: NSOrderedSet!
    private var ingredientsInfos: [IngredientAPI]!

    
    // MARK: - OVERRIDE TEST FUNCTIONS
    override func setUp() {
        super.setUp()
        
        ingredientConfiguration = IngredientConfiguration()
        
        ingredientsOrderedSet = NSOrderedSet()
        ingredientsInfos = [IngredientAPI(text: "DetailledIngredients1", food: "Tomato"),
                            IngredientAPI(text: "DetailledIngredients2", food: "Banana")]
    }
    
    // MARK: - TESTS FOR RESEARCH
    func testAddIngredientOnEmptyList() {
        let notificationExpectation = expectation(forNotification: .ingredientsListModified, object: nil, handler: nil)

        ingredientConfiguration.addIngredient(ingredient: "Tomato")

        let result = XCTWaiter.wait(for: [notificationExpectation], timeout: 0.1)
        
        // Check if Notification is posted
        if result == .completed {
            // Posted
            XCTAssertEqual(ingredientConfiguration.ingredients[0], "Tomato")
        } else {
            // Not posted
            XCTFail()
        }
    }
    
    func testAddIngredientOnExistingList() {
        let notificationExpectation = expectation(forNotification: .ingredientsListModified, object: nil, handler: nil)

        ingredientConfiguration.ingredients = ["Banana"]
        ingredientConfiguration.addIngredient(ingredient: "Tomato")

        let result = XCTWaiter.wait(for: [notificationExpectation], timeout: 0.1)
        
        // Check if Notification is posted
        if result == .completed {
            // Posted
            XCTAssertEqual(ingredientConfiguration.ingredients[0], "Banana")
            XCTAssertEqual(ingredientConfiguration.ingredients[1], "Tomato")
        } else {
            // Not posted
            XCTFail()
        }
    }
    
    func testRemoveAnIngredient() {
        let notificationExpectation = expectation(forNotification: .ingredientsListModified, object: nil, handler: nil)

        ingredientConfiguration.ingredients = ["Banana", "Tomato"]
        XCTAssertNoThrow(try ingredientConfiguration.removeIngredients(at: 0))
        
        let result = XCTWaiter.wait(for: [notificationExpectation], timeout: 0.1)
        
        if result == .completed {
            XCTAssertEqual(ingredientConfiguration.ingredients[0], "Tomato")
        } else {
            XCTFail()
        }
    }
    
    func testRemoveAnIngredientFromEmptyList() {
        XCTAssertThrowsError(try ingredientConfiguration.removeIngredients(at: 0)) { (error) in
            if let error = error as? IngredientConfiguration.IngredientsErrors {
                XCTAssertEqual(error, .removeOneError)
                XCTAssertEqual(error.localizedDescription, "No ingredient to delete.")
            } else {
                XCTFail("An unexpected error occurred: \(error)")
            }
        }
    }
    
    func testRemoveAllIngredients() {
        let notificationExpectation = expectation(forNotification: .ingredientsListModified, object: nil, handler: nil)

        ingredientConfiguration.ingredients = ["Banana", "Tomato", "Cherry"]

        XCTAssertNoThrow(try ingredientConfiguration.removeAllIngredients())

        let result = XCTWaiter.wait(for: [notificationExpectation], timeout: 0.1)

        if result == .completed {
            XCTAssertTrue(ingredientConfiguration.ingredients.isEmpty)
        } else {
            XCTFail()
        }
    }
    
    func testRemoveAllIngredientsFromEmptyList() {        
        XCTAssertThrowsError(try ingredientConfiguration.removeAllIngredients()) { (error) in
            if let error = error as? IngredientConfiguration.IngredientsErrors {
                XCTAssertEqual(error, .removeAllError)
                XCTAssertEqual(error.localizedDescription, "Empty recipes list. Please add at least an ingredient.")
            } else {
                XCTFail("An unexpected error occurred: \(error)")
            }
        }
    }
    
    func testFormatIngredientsInOneLine() {
        let formatedIngredients = ingredientConfiguration.formatIngredientsInOneLine(ingredientsFood: ingredientsInfos)
        XCTAssertEqual(formatedIngredients, "Tomato, Banana")
    }
    
    func testFormatIngredientsInOneLineFromEmptyList() {
        let emptyIngredientsInfos: [IngredientAPI] = []
        
        let formatedIngredients = ingredientConfiguration.formatIngredientsInOneLine(ingredientsFood: emptyIngredientsInfos)
        XCTAssertEqual(formatedIngredients, "")
    }
    
    func testFormatDetailledIngredientsInSeparateLines() {
        let formatedDetailledIngredients = ingredientConfiguration.formatDetailledIngredientsInSeparateLines(ingredients: ingredientsInfos)
        XCTAssertEqual(formatedDetailledIngredients, "- DetailledIngredients1\n- DetailledIngredients2\n")
    }
    
    func testFormatDetailledIngredientsInSeparateLinesFromEmptyList() {
        let emptyIngredientsInfos: [IngredientAPI] = []

        let formatedDetailledIngredients = ingredientConfiguration.formatDetailledIngredientsInSeparateLines(ingredients: emptyIngredientsInfos)
        XCTAssertEqual(formatedDetailledIngredients, "")
    }
    
    // MARK: - TESTS FOR FAVORITES
    func testFormatFavoriteIngredientsInOneLine() {
        ingredientsOrderedSet = NSOrderedSet(array: [
            ["food": "Carrots"],
            ["food": "Peppers"],
            ["food": "Onions"]
        ])
        
        let result = ingredientConfiguration.formatFavoriteIngredientsInOneLine(ingredients: ingredientsOrderedSet)
        XCTAssertEqual(result, "Carrots, Peppers, Onions")
    }
    
    func testFormatFavoriteIngredientsInOneLineFromEmptyList() {
        let result = ingredientConfiguration.formatFavoriteIngredientsInOneLine(ingredients: ingredientsOrderedSet)
        XCTAssertEqual(result, "")
    }
    
    func testFormatFavoritesDetailledIngredientsInSeparateLines() {
        let detailledIngredients = NSOrderedSet(array: [
            ["text": "Wash the carrots"],
            ["text": "Chop the peppers"],
            ["text": "Slice the onions"]
        ])
        
        let result = ingredientConfiguration.formatFavoritesDetailledIngredientsInSeparateLines(ingredients: detailledIngredients)
        XCTAssertEqual(result, "- Wash the carrots\n- Chop the peppers\n- Slice the onions\n")
    }
    
    func testFormatFavoritesDetailledIngredientsInSeparateLinesFromEmptyList() {
        let result = ingredientConfiguration.formatFavoritesDetailledIngredientsInSeparateLines(ingredients: ingredientsOrderedSet)
        XCTAssertEqual(result, "")
    }
}
