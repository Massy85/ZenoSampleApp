//
//  SetPanelModeMockTestAPI.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 20/04/22.
//

import XCTest
@testable import Zeno_sample_app

class SetPanelModeMockTestAPI: XCTestCase {

    func test_success_case_with_bypass_1() {
        let expectation = expectation(description: "waiting for completion")
        var sutError: Error? = nil
        var sutPanelModePostMO: PanelModePostMO? = nil
        let sut = MockHelper(result: true)
        
        sut.perform { result in
            switch result {
            case .success(let panelModePostMO):
                sutPanelModePostMO = panelModePostMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutError)
        XCTAssertNotNil(sutPanelModePostMO)
    }
    
    func test_failure_case_with_bypass_0_and_faults() {
        let expectation = expectation(description: "waiting for completion")
        var sutError: Error? = nil
        var sutPanelModePostMO: PanelModePostMO? = nil
        let sut = MockHelper(result: false)
        
        sut.perform { result in
            switch result {
            case .success(let panelModePostMO):
                sutPanelModePostMO = panelModePostMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutPanelModePostMO)
        XCTAssertNotNil(sutError)
    }
    
    func test_failure_case_with_statusCode_400() {
        let expectation = expectation(description: "waiting for completion")
        var sutError: Error? = nil
        var sutPanelModePostMO: PanelModePostMO? = nil
        let sut = MockHelper(result: false, statusCode: 400)
        
        sut.perform { result in
            switch result {
            case .success(let panelModePostMO):
                sutPanelModePostMO = panelModePostMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutPanelModePostMO)
        XCTAssertNotNil(sutError)
    }
    
    private class MockHelper {
        let jsonData: Data
        let statusCode: Int
        
        init(result: Bool, statusCode: Int = 200) {
            self.statusCode = statusCode
            if result {
                self.jsonData = Helper.setPanelModeJSONWithBypass1()
            } else {
                self.jsonData = Helper.setPanelModeJSONWithBypass0()
            }
        }
        
        func perform(_ completion: @escaping (SetPanelModeLoaderAdapter.Result) -> Void) {
            let response = HTTPURLResponse(url: URL(string: "my.url")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            completion(PostPanelModeMapper.map(jsonData, response))
        }
    }
}
