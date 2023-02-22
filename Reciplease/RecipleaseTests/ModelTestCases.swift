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
    // MARK: - VARIABLES
    private var ingredientConfiguration: IngredientConfiguration!
    private var ingredientsOrderedSet: NSOrderedSet!
    private var ingredientsInfos: [IngredientInfos]!

    
    // MARK: - OVERRIDE TEST FUNCTIONS
    override func setUp() {
        super.setUp()
        
        ingredientConfiguration = IngredientConfiguration()
        
        ingredientsOrderedSet = NSOrderedSet()
        ingredientsInfos = [IngredientInfos(text: "Instruction1", food: "Tomato"),
                            IngredientInfos(text: "Instruction2", food: "Banana")]
    }
    
    // MARK: - TESTS FOR RESEARCH
    func testAddIngredientOnEmptyList() {
        let notificationExpectation = expectation(forNotification: .ingredientsListModified, object: nil, handler: nil)

        ingredientConfiguration.addIngredient(ingredient: "Tomato")

        let result = XCTWaiter.wait(for: [notificationExpectation], timeout: 0.2)
        
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

        let result = XCTWaiter.wait(for: [notificationExpectation], timeout: 0.2)
        
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

        ingredientConfiguration.removeIngredients(at: 0)
        
        let result = XCTWaiter.wait(for: [notificationExpectation], timeout: 0.2)

        if result == .completed {
            XCTAssertEqual(ingredientConfiguration.ingredients[0], "Tomato")
        } else {
            XCTFail()
        }
    }
    
    func testRemoveAllIngredients() {
        let notificationExpectation = expectation(forNotification: .ingredientsListModified, object: nil, handler: nil)

        ingredientConfiguration.ingredients = ["Banana", "Tomato", "Cherry"]

        ingredientConfiguration.removeAllIngredients()
        
        let result = XCTWaiter.wait(for: [notificationExpectation], timeout: 0.2)

        if result == .completed {
            XCTAssertTrue(ingredientConfiguration.ingredients.isEmpty)
        } else {
            XCTFail()
        }
    }
    
    func testFormatIngredientsInOneLine() {
        let formatedIngredients = ingredientConfiguration.formatIngredientsInOneLine(ingredientsFood: ingredientsInfos)
        XCTAssertEqual(formatedIngredients, "Tomato, Banana")
    }
    
    func testFormatInstructions() {
        let formatedInstructions = ingredientConfiguration.formatInstructions(ingredients: ingredientsInfos)
        XCTAssertEqual(formatedInstructions, "- Instruction1\n- Instruction2\n")

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
    
    func testFormatFavoritesInstructions() {
        let instructions = NSOrderedSet(array: [
            ["text": "Wash the carrots"],
            ["text": "Chop the peppers"],
            ["text": "Slice the onions"]
        ])
        
        let result = ingredientConfiguration.formatFavoritesInstructions(ingredients: instructions)
        XCTAssertEqual(result, "- Wash the carrots\n- Chop the peppers\n- Slice the onions\n")
    }
}
