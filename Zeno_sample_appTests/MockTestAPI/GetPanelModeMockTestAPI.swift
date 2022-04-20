//
//  GetPanelModeMockTestAPI.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 20/04/22.
//

import XCTest
@testable import Zeno_sample_app

class GetPanelModeMockTestAPI: XCTestCase {
    
    func test_success_case_with_burglar_true() {
        var sutPanelModeMO: PanelModeMO? = nil
        var sutError: Error? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(result: true, isBurglar: true)
        
        sut.perform { result in
            switch result {
            case .success(let panelModeMO):
                sutPanelModeMO = panelModeMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutError)
        XCTAssertNotNil(sutPanelModeMO)
        XCTAssertEqual(sutPanelModeMO?.burglar, true)
    }
    
    func test_success_case_with_burglar_false() {
        var sutPanelModeMO: PanelModeMO? = nil
        var sutError: Error? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(result: true, isBurglar: true)
        
        sut.perform { result in
            switch result {
            case .success(let panelModeMO):
                sutPanelModeMO = panelModeMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutError)
        XCTAssertNotNil(sutPanelModeMO)
    }
    
    func test_case_failure_with_error() {
        var sutPanelModeMO: PanelModeMO? = nil
        var sutError: Error? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(result: false, isBurglar: false)
        
        sut.perform { result in
            switch result {
            case .success(let panelModeMO):
                sutPanelModeMO = panelModeMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNotNil(sutError)
        XCTAssertNil(sutPanelModeMO)
    }
    
    func test_case_failure_with_statusCode_400() {
        var sutPanelModeMO: PanelModeMO? = nil
        var sutError: Error? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(result: false, isBurglar: false, statusCode: 400)
        
        sut.perform { result in
            switch result {
            case .success(let panelModeMO):
                sutPanelModeMO = panelModeMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNotNil(sutError)
        XCTAssertNil(sutPanelModeMO)
    }

    // MARK: - Helper

    private class MockHelper {
        let jsonData: Data
        let statusCode: Int
        
        init(result: Bool, isBurglar: Bool, statusCode: Int = 200) {
            self.statusCode = statusCode
            if isBurglar {
                self.jsonData = Helper.getPanelModeJSONWithValidData(result: result, isBurglar: isBurglar)
            } else {
                self.jsonData = Helper.getPanelModeJSONWithInvalidData(result: result)
            }
        }
        
        func perform(_ completion: @escaping (GetPanelModeLoaderAdapter.Result) -> Void) {
            let response = HTTPURLResponse(url: URL(string: "my.url")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            completion(GetPanelModeMapper.map(jsonData, response))
        }
    }
}
