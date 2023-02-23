//
//  MockURLProtocol.swift
//  RecipleaseTests
//
//  Created by Mickaël Horn on 21/02/2023.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        // We return true in order to allow URLSession to use this protocol for any URL Request
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    static var loadingHandler: ((URLRequest) -> (Data?, HTTPURLResponse?, Error?))?
    
    override func startLoading() {
        guard let handler = MockURLProtocol.loadingHandler else {
            print("Loading handler is not set.")
            return
        }
        
        let (data, response, error) = handler(request)
        
        guard error == nil else {
            client?.urlProtocol(self, didFailWithError: error!)
            return
        }
        
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
