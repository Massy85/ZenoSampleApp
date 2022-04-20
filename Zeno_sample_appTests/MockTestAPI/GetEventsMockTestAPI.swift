//
//  GetEventsMockTestAPI.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 20/04/22.
//

import XCTest
@testable import Zeno_sample_app

class GetEventsMockTestAPI: XCTestCase {
    
    func test_success_with_events() {
        var sutError: Error? = nil
        var sutEventMO: EventMO? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(eventsArePresent: true)
        
        sut.perform { result in
            switch result {
            case .success(let eventMO):
                sutEventMO = eventMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutError)
        XCTAssertNotNil(sutEventMO)
    }
    
    func test_success_with_no_events() {
        var sutError: Error? = nil
        var sutEventMO: EventMO? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(eventsArePresent: false)
        
        sut.perform { result in
            switch result {
            case .success(let eventMO):
                sutEventMO = eventMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutError)
        XCTAssertNotNil(sutEventMO)
    }
    
    func test_success_with_statusCode400() {
        var sutError: Error? = nil
        var sutEventMO: EventMO? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(statusCode: 400, eventsArePresent: true)
        
        sut.perform { result in
            switch result {
            case .success(let eventMO):
                sutEventMO = eventMO
            case .failure(let error):
                if case GetEventsLoaderAdapter.Error.invalidData = error {
                    sutError = error
                } else {
                    sutError = nil
                }
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutEventMO)
        XCTAssertNotNil(sutError)
    }

    private class MockHelper {
        let jsonData: Data
        let statusCode: Int
        
        init(statusCode: Int = 200, eventsArePresent: Bool) {
            self.statusCode = statusCode
            if eventsArePresent {
                self.jsonData = Helper.getEventJSONWithEvents()
            } else {
                self.jsonData = Helper.getEventJSONWithoutEvents()
            }
        }
        
        func perform(_ completion: @escaping (GetEventsLoaderAdapter.Result) -> Void) {
            let response = HTTPURLResponse(url: URL(string: "my.url")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            completion(EventsMapper.map(jsonData, response))
        }
    }
}
