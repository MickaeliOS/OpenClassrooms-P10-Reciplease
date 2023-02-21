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
    
    private var client: APICallCenter!
    private var expectation = XCTestExpectation()
    
    override func setUp() {
        super.setUp()
        
        let manager: Session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()
            
            return Session(configuration: configuration)
        }()
        
        client = APICallCenter(manager: manager)
        client.delegate = self
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
    }
    
    func testGivenIngredients_WhenPerformingRequest_ThenRequestSuccess() {
        let dataFake = FakeResponseDataError.correctData
        let responseFake = FakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (dataFake, responseFake, nil)
        }
        
        expectation = XCTestExpectation(description: "Performs a request")
        
        client.getRecipes(ingredients: "chicken, tomato", nbIngredients: "2")
                
        wait(for: [expectation], timeout: 10)
    }
}

extension APITestCases: APICallCenterDelegate {
    func getRecipesDidFinish(result: [Reciplease.RecipeInfos]?, nextPage: Reciplease.Next?) {
        guard let result = result else { return }
        
        XCTAssertEqual(result[0].label, "The Ultimate Burger")
        XCTAssertEqual(result[1].label, "Steph's Shredded Chicken Tacos")
        expectation.fulfill()
    }

    func getRecipesDidFail() {
        //todo
    }
    
    func getNextPageDidFinish(result: [Reciplease.RecipeInfos]?, nextPage: Reciplease.Next?) {
        //todo

    }
    
    func getNextPageDidFail() {
        //todo

    }
}
