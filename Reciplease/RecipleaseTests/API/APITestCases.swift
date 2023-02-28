//
//  APITestCases.swift
//  RecipleaseTests
//
//  Created by Mickaël Horn on 21/02/2023.
//

import XCTest
import Alamofire
@testable import Reciplease

final class APITestCases: XCTestCase {
    // MARK: - PROPERTIES
    private var client: APICallCenter!
    private var expectedResponse: String!
    private var expectation: XCTestExpectation = XCTestExpectation(description: "Performs a request")
    private var manager: Session! = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockURLProtocol.self]
            return configuration
        }()
        return Session(configuration: configuration)
    }()
    
    // MARK: - OVERRIDE TEST FUNCTIONS
    override func setUp() {
        super.setUp()
            
        client = APICallCenter(manager: manager)
        client.delegate = self
    }
    
    // MARK: - SEARCH RECIPES TESTING
    func testSearchRequestSuccessIfSetCorrectly() {
        let dataFake = FakeResponseDataError.correctData
        let responseFake = FakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (dataFake, responseFake, nil)
        }
                
        client.getRecipes(ingredients: "ingredients", nbIngredients: "nbIngredients")
                
        wait(for: [expectation], timeout: 0.02)
        XCTAssertEqual(expectedResponse, "getRecipesDidFinish")
    }
    
    func testSearchRequestFailsWithEmptyRecipes() {
        let dataFake = FakeResponseDataError.emptyRecipesData
        let responseFake = FakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (dataFake, responseFake, nil)
        }
                
        client.getRecipes(ingredients: "ingredients", nbIngredients: "nbIngredients")
                
        wait(for: [expectation], timeout: 0.02)
        XCTAssertEqual(expectedResponse, "getRecipesDidFailWithEmptyRecipes")
    }
    
    func testSearchRequestFailsWithIncorrectResponse() {
        let dataFake = FakeResponseDataError.correctData
        let responseFake = FakeResponseDataError.responseKO

        MockURLProtocol.loadingHandler = { request in
            return (dataFake, responseFake, nil)
        }
        
        client.getRecipes(ingredients: "ingredients", nbIngredients: "nbIngredients")
                
        wait(for: [expectation], timeout: 0.02)
        XCTAssertEqual(expectedResponse, "getRecipesDidFailWithIncorrectResponse")
    }
    
    func testSearchRequestFailsWithError() {
        let error = FakeResponseDataError.error

        MockURLProtocol.loadingHandler = { request in
            return (nil, nil, error)
        }
        
        client.getRecipes(ingredients: "ingredients", nbIngredients: "nbIngredients")
                
        wait(for: [expectation], timeout: 0.02)
        XCTAssertEqual(expectedResponse, "getRecipesDidFailWithError")
    }
    
    // MARK: - NEXTPAGE RECIPES TESTING
    func testNextPageRequestSuccessIfSetCorrectly() {
        let dataFake = FakeResponseDataError.correctData
        let responseFake = FakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (dataFake, responseFake, nil)
        }
                
        client.getNextPage(nextPage: Next(href: "url"))
                
        wait(for: [expectation], timeout: 0.02)
        XCTAssertEqual(expectedResponse, "getNextPageDidFinish")
    }
    
    func testNextPageRequestFailsWithEmptyRecipes() {
        let dataFake = FakeResponseDataError.emptyRecipesData
        let responseFake = FakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (dataFake, responseFake, nil)
        }
                
        client.getNextPage(nextPage: Next(href: "url"))
                
        wait(for: [expectation], timeout: 0.02)
        XCTAssertEqual(expectedResponse, "getNextPageDidFailWithEmptyRecipes")
    }
    
    func testNextPageRequestFailsWithIncorrectResponse() {
        let dataFake = FakeResponseDataError.correctData
        let responseFake = FakeResponseDataError.responseKO

        MockURLProtocol.loadingHandler = { request in
            return (dataFake, responseFake, nil)
        }
        
        client.getNextPage(nextPage: Next(href: "url"))
                
        wait(for: [expectation], timeout: 0.02)
        XCTAssertEqual(expectedResponse, "getNextPageDidFailWithIncorrectResponse")
    }
    
    func testNextPageRequestFailsWithError() {
        let error = FakeResponseDataError.error

        MockURLProtocol.loadingHandler = { request in
            return (nil, nil, error)
        }
        
        client.getNextPage(nextPage: Next(href: "url"))

        wait(for: [expectation], timeout: 0.02)
        XCTAssertEqual(expectedResponse, "getNextPageDidFailWithError")
    }
}

// MARK: - APICALLCENTER DELEGATE
extension APITestCases: APICallCenterDelegate {
    
    func getRecipesDidFinish(recipes: [Reciplease.RecipeInfos], nextPage: Reciplease.Next?) {
        // With recipes, but without nextPage
        guard let _ = nextPage else {
            controlRecipes(result: recipes)
            expectedResponse = "getRecipesDidFinish"
            expectation.fulfill()
            return
        }
        
        //TODO: With recipes + nextPage
    }
    
    func getRecipesDidFailWithError() {
        expectedResponse = "getRecipesDidFailWithError"
        expectation.fulfill()
    }
    
    func getRecipesDidFailWithIncorrectResponse() {
        expectedResponse = "getRecipesDidFailWithIncorrectResponse"
        expectation.fulfill()
    }
    
    func getRecipesDidFailWithEmptyRecipes() {
        expectedResponse = "getRecipesDidFailWithEmptyRecipes"
        expectation.fulfill()
    }
    
    func getNextPageDidFinish(recipes: [Reciplease.RecipeInfos], nextPage: Reciplease.Next?) {
        expectedResponse = "getNextPageDidFinish"
        expectation.fulfill()
    }
    
    func getNextPageDidFailWithError() {
        expectedResponse = "getNextPageDidFailWithError"
        expectation.fulfill()
    }
    
    func getNextPageDidFailWithIncorrectResponse() {
        expectedResponse = "getNextPageDidFailWithIncorrectResponse"
        expectation.fulfill()
    }
    
    func getNextPageDidFailWithEmptyRecipes() {
        expectedResponse = "getNextPageDidFailWithEmptyRecipes"
        expectation.fulfill()
    }
}

//MARK: - EXTENSIONS
extension APITestCases {
    private func controlRecipes(result: [Reciplease.RecipeInfos]) {
        // Control the first recipe
        XCTAssertEqual(result[0].label, "The Ultimate Burger")
        XCTAssertEqual(result[0].image, "https://edamam-product-images.s3.amazonaws.com/web-img/05f/05f6b1fbd22e92e2f7ba32026abe1714.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjECQaCXVzLWVhc3QtMSJIMEYCIQD%2F5bCx2hbQPLWZoPGemdHsQYBPQPmxcO0YvMmXY%2BEmFwIhALu1eHQZkEx%2F9bmV6onFOT1NkzSULo8l8F1zE2rHWF2iKtUECL3%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQABoMMTg3MDE3MTUwOTg2Igzn%2Fk%2BAtL%2F0%2FTiDaOUqqQS0Ls%2BHf8UTq3Gfd23sMlymsZ%2BNzMHQD%2Fq%2BhklJZj7YRyeOMvo%2FdnE4aPu2oB6%2B1a8UVBRr%2F36QJGtHesmpc7bfnr2QXc8nnNBv3c1ApZ0nGHkv9Yh8Eb4ahxok8cW1%2Fukf0hPIQzVAhocHiAUDShsmq7go0TMkyJvlemzHvIajwi44Ko8k%2Biy10rghlTWiYJ05svxScNusdAVHgDgy6MN9NsdXgvrksWZV7bf7D0psl6M7Pq1uPcQTf6ICSgofH3t4E8bhwGGFaCCk0Y4xsbzUKqJ1SeidEnxRitAgoJVWyKVtD31IR4zbyQ509hxvGFbPC0IaMEEnIy6GbGU29UOJfPSQMgnwxC%2F3GEkyWeJRibwRQWAbOrYJWL7YuCfmIpVwVeAM71hmdFd2FF2WpqQn0KwZAqeu7h2gVW%2B3whSI%2FUpFkbdS9NGaC2JIusUhC8c%2Fc1aUZj4lMEd6Duw5XbSQ8bg255ox9GrRGvvmchQpAdcJymonV%2BEvsu1fMsB44z1JXPkxyeAlHOEyIq%2F%2FG9G58A8kHnOZCxwK1At3lTGUPb%2FJt5qkrIYgXst0g07e9sNxVusdoZScGuu%2F%2B7Rp9OquPgjXkN2H3oGMlyM7IFlQLEx7cBcxDJ7iMP6bbxxEk6AsqIxSYZYjQ%2BubA80LGBDqUnw%2FEQUUEAUPB5%2FqMt5wTziseqs7lJqE4uPtTqA7Lz%2FGAk49Ldo9prcUInvqiW8DAPryh4UsVoMqMPzg0p8GOqgBidUFZTzI%2FRMvnE5%2BfNZ9ImDhdyhMHcP8nzFA8x%2BrKmOLxDUQLHn%2BTm3hAp9%2BcPN0eQ2q8O0rQLFgoZMYGtXasYNAgUXvFGYul%2BAVm17bo9C8AOEFk5r3sfANakjSSLGTzx0anygDMfnPUhtwG7IrUIRwWdv1xBFphIidjDeN1vqS1k9UJdcooWWbpKQnMdmNSYshSnZcreij%2B1%2BT%2F5uFwNx1iUS2BxnY&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230221T123916Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIASXCYXIIFIZ3A6EYO%2F20230221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=8175fe896a41f1384bfa3ef3ced276dc784d80431688a8e5c06a672975e0ab8a")
        XCTAssertEqual(result[0].ingredients[0].text, "2 1/2 pounds skirt steak or sirloin flap steak")
        XCTAssertEqual(result[0].ingredients[0].food, "flap steak")
        XCTAssertEqual(result[0].ingredients[1].text, "Accompaniments: homemade burger buns ; homemade ketchup ; homemade mustard ; homemade pickle relish ; lettuce and tomato")
        XCTAssertEqual(result[0].ingredients[1].food, "ketchup")
        XCTAssertEqual(result[0].url, "https://www.epicurious.com/recipes/food/views/the-ultimate-burger-353654")
        XCTAssertEqual(result[0].totalTime, 0.0)

        // Control the second recipe
        XCTAssertEqual(result[1].label, "Steph's Shredded Chicken Tacos")
        XCTAssertEqual(result[1].image, "https://edamam-product-images.s3.amazonaws.com/web-img/b76/b763c8c37b5382c7a483d0740e4a724a?X-Amz-Security-Token=IQoJb3JpZ2luX2VjECQaCXVzLWVhc3QtMSJIMEYCIQD%2F5bCx2hbQPLWZoPGemdHsQYBPQPmxcO0YvMmXY%2BEmFwIhALu1eHQZkEx%2F9bmV6onFOT1NkzSULo8l8F1zE2rHWF2iKtUECL3%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQABoMMTg3MDE3MTUwOTg2Igzn%2Fk%2BAtL%2F0%2FTiDaOUqqQS0Ls%2BHf8UTq3Gfd23sMlymsZ%2BNzMHQD%2Fq%2BhklJZj7YRyeOMvo%2FdnE4aPu2oB6%2B1a8UVBRr%2F36QJGtHesmpc7bfnr2QXc8nnNBv3c1ApZ0nGHkv9Yh8Eb4ahxok8cW1%2Fukf0hPIQzVAhocHiAUDShsmq7go0TMkyJvlemzHvIajwi44Ko8k%2Biy10rghlTWiYJ05svxScNusdAVHgDgy6MN9NsdXgvrksWZV7bf7D0psl6M7Pq1uPcQTf6ICSgofH3t4E8bhwGGFaCCk0Y4xsbzUKqJ1SeidEnxRitAgoJVWyKVtD31IR4zbyQ509hxvGFbPC0IaMEEnIy6GbGU29UOJfPSQMgnwxC%2F3GEkyWeJRibwRQWAbOrYJWL7YuCfmIpVwVeAM71hmdFd2FF2WpqQn0KwZAqeu7h2gVW%2B3whSI%2FUpFkbdS9NGaC2JIusUhC8c%2Fc1aUZj4lMEd6Duw5XbSQ8bg255ox9GrRGvvmchQpAdcJymonV%2BEvsu1fMsB44z1JXPkxyeAlHOEyIq%2F%2FG9G58A8kHnOZCxwK1At3lTGUPb%2FJt5qkrIYgXst0g07e9sNxVusdoZScGuu%2F%2B7Rp9OquPgjXkN2H3oGMlyM7IFlQLEx7cBcxDJ7iMP6bbxxEk6AsqIxSYZYjQ%2BubA80LGBDqUnw%2FEQUUEAUPB5%2FqMt5wTziseqs7lJqE4uPtTqA7Lz%2FGAk49Ldo9prcUInvqiW8DAPryh4UsVoMqMPzg0p8GOqgBidUFZTzI%2FRMvnE5%2BfNZ9ImDhdyhMHcP8nzFA8x%2BrKmOLxDUQLHn%2BTm3hAp9%2BcPN0eQ2q8O0rQLFgoZMYGtXasYNAgUXvFGYul%2BAVm17bo9C8AOEFk5r3sfANakjSSLGTzx0anygDMfnPUhtwG7IrUIRwWdv1xBFphIidjDeN1vqS1k9UJdcooWWbpKQnMdmNSYshSnZcreij%2B1%2BT%2F5uFwNx1iUS2BxnY&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230221T123916Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIASXCYXIIFIZ3A6EYO%2F20230221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=e46f9a731548a8cab5370fc899a09a4738e30ea598b1f13ee08d35a5217d648d")
        XCTAssertEqual(result[1].ingredients[0].text, "3 Boneless, Skinless Chicken Breasts")
        XCTAssertEqual(result[1].ingredients[0].food, "Boneless, Skinless Chicken Breasts")
        XCTAssertEqual(result[1].ingredients[1].text, "10 ounces cans of Red Enchilada Sauce")
        XCTAssertEqual(result[1].ingredients[1].food, "Enchilada Sauce")
        XCTAssertEqual(result[1].url, "http://www.foodista.com/recipe/WM652VQB/stephs-shredded-chicken-tacos")
        XCTAssertEqual(result[1].totalTime, 0.0)
    }
}
