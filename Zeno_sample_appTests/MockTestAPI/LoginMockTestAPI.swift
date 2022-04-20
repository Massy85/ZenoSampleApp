//
//  LoginMockTestAPI.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 19/04/22.
//

import XCTest
@testable import Zeno_sample_app

class LoginMockTestAPI: XCTestCase {

    func test_success_case() {
        var sutLoginMO: LoginMO? = nil
        var sutError: Error? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(dataIsValid: true, result: true)
        
        sut.perform { result in
            switch result {
            case .success(let loginMO):
                sutLoginMO = loginMO
            case .failure(let error):
                sutError = error
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNotNil(sutLoginMO)
        XCTAssertNil(sutError)
    }
    
    func test_case_statusCode_is_not_200() {
        var sutLoginMO: LoginMO? = nil
        var sutError: Error? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(statusCode: 400, dataIsValid: true, result: true)
        
        sut.perform { result in
            switch result {
            case .success(let loginMO):
                sutLoginMO = loginMO
            case .failure(let error):
                sutError = error
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNotNil(sutError)
        XCTAssertNil(sutLoginMO)
    }
    
    func test_case_with_invalid_data() {
        var sutLoginMO: LoginMO? = nil
        var sutError: Error? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(dataIsValid: false, result: true)
        
        sut.perform { result in
            switch result {
            case .success(let loginMO):
                sutLoginMO = loginMO
            case .failure(let error):
                sutError = error
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutError)
        XCTAssertNotNil(sutLoginMO)
        XCTAssertEqual(sutLoginMO?.id, ZenoClient.nullValue)
        XCTAssertEqual(sutLoginMO?.mac, ZenoClient.nullValue)
    }
    
    func test_case_result_is_false_and_statusCode_200() {
        var sutLoginMO: LoginMO? = nil
        var sutError: Error? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(statusCode: 200, dataIsValid: true, result: false)
        
        sut.perform { result in
            switch result {
            case .success(let loginMO):
                sutLoginMO = loginMO
            case .failure(let error):
                sutError = error
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNotNil(sutError)
        XCTAssertNil(sutLoginMO)
    }

    // MARK: - Helper
    
    private class MockHelper {
        let jsonData: Data
        let statusCode: Int
        
        init(statusCode: Int = 200, dataIsValid: Bool, result: Bool) {
            self.statusCode = statusCode
            if dataIsValid {
                self.jsonData = Helper.loginJSONWithValidData(result: result)
            } else {
                self.jsonData = Helper.loginJSONWithNotValidData(result: result)
            }
        }
        
        func perform(_ completion: @escaping (LoginLoaderAdapter.Result) -> Void) {
            let response = HTTPURLResponse(url: URL(string: "my.url")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            completion(LoginMapper.map(jsonData, response))
        }
    }
}
