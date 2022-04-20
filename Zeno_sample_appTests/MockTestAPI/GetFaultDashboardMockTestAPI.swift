//
//  GetFaultDashboardMockTestAPI.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 20/04/22.
//

import XCTest
@testable import Zeno_sample_app

class GetFaultDashboardMockTestAPI: XCTestCase {
    
    func test_success_with_faults() {
        let expectation = expectation(description: "waiting for completion")
        var sutError: Error? = nil
        var sutDashboardMO: DashboardMO? = nil
        let sut = MockHelper(faultsArePresent: true)
        
        sut.perform { result in
            switch result {
            case .success(let dashboardMO):
                sutDashboardMO = dashboardMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutError)
        XCTAssertNotNil(sutDashboardMO)
    }
    
    func test_success_without_faults() {
        let expectation = expectation(description: "waiting for completion")
        var sutError: Error? = nil
        var sutDashboardMO: DashboardMO? = nil
        let sut = MockHelper(faultsArePresent: false)
        
        sut.perform { result in
            switch result {
            case .success(let dashboardMO):
                sutDashboardMO = dashboardMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutError)
        XCTAssertNotNil(sutDashboardMO)
        XCTAssert(sutDashboardMO?.dcFaultsNumber == 0)
        XCTAssert(sutDashboardMO?.deviceFaultsNumber == 0)
    }
    
    func test_failure_with_statusCode400() {
        let expectation = expectation(description: "waiting for completion")
        var sutError: Error? = nil
        var sutDashboardMO: DashboardMO? = nil
        let sut = MockHelper(statusCode: 400, faultsArePresent: true)
        
        sut.perform { result in
            switch result {
            case .success(let dashboardMO):
                sutDashboardMO = dashboardMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutDashboardMO)
        XCTAssertNotNil(sutError)
    }

    // MARK: - Helper

    private class MockHelper {
        let jsonData: Data
        let statusCode: Int
        
        init(statusCode: Int = 200, faultsArePresent: Bool) {
            self.statusCode = statusCode
            
            if faultsArePresent {
                self.jsonData = Helper.getFaultDashboardWithFaults()
            } else {
                self.jsonData = Helper.getFaultDashboardWithoutFaults()
            }
        }
        
        func perform(_ completion: @escaping (GetFaultDashboardAdapter.Result) -> Void) {
            let response = HTTPURLResponse(url: URL(string: "my.url")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            completion(FaultDashboardMapper.map(jsonData, response))
        }
    }

}
