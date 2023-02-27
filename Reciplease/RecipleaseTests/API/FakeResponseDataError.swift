//
//  FakeResponseDataError.swift
//  RecipleaseTests
//
//  Created by Mickaël Horn on 21/02/2023.
//

import Foundation

class FakeResponseDataError {
    //MARK: - DATAS
    static var correctData: Data {
        let bundle = Bundle(for: FakeResponseDataError.self)
        let url = bundle.url(forResource: "Recipe", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var emptyRecipesData: Data {
        let bundle = Bundle(for: FakeResponseDataError.self)
        let url = bundle.url(forResource: "EmptyRecipe", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
        
    //MARK: - RESPONSES
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    //MARK: - ERRORS
    class ExchangeError: Error {}
    static let error = ExchangeError()
}
