//
//  GetPanelDeviceMockTestAPI.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 20/04/22.
//

import XCTest
@testable import Zeno_sample_app

class GetPanelDeviceMockTestAPI: XCTestCase {

    func test_success_with_no_devices() {
        var sutError: Error? = nil
        var sutPanelDeviceMO: PanelDeviceMO? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(devicesArePresent: false)
        
        sut.perform { result in
            switch result {
            case .success(let panelDeviceMO):
                sutPanelDeviceMO = panelDeviceMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutError)
        XCTAssertNotNil(sutPanelDeviceMO)
        XCTAssertEqual(sutPanelDeviceMO?.data, nil)
    }
    
    func test_success_with_devices() {
        var sutError: Error? = nil
        var sutPanelDeviceMO: PanelDeviceMO? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(devicesArePresent: true)
        
        sut.perform { result in
            switch result {
            case .success(let panelDeviceMO):
                sutPanelDeviceMO = panelDeviceMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutError)
        XCTAssertNotNil(sutPanelDeviceMO)
        XCTAssert(sutPanelDeviceMO?.data?.count ?? 0 > 0)
        XCTAssertNotEqual(sutPanelDeviceMO?.data, nil)
    }
    
    func test_failure_with_statusCode400() {
        var sutError: Error? = nil
        var sutPanelDeviceMO: PanelDeviceMO? = nil
        let expectation = expectation(description: "waiting for completion")
        let sut = MockHelper(statusCode: 400, devicesArePresent: true)
        
        sut.perform { result in
            switch result {
            case .success(let panelDeviceMO):
                sutPanelDeviceMO = panelDeviceMO
            case .failure(let error):
                sutError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(sutPanelDeviceMO)
        XCTAssertNotNil(sutError)
    }
    
    // MARK: - Helper

    private class MockHelper {
        let jsonData: Data
        let statusCode: Int
        
        init(statusCode: Int = 200, devicesArePresent: Bool) {
            self.statusCode = statusCode
            
            if devicesArePresent {
                self.jsonData = Helper.getPanelDeviceJSONWithDevicesPresent()
            } else {
                self.jsonData = Helper.getPanelDeviceJSONWithoutDevices()
            }
        }
        
        func perform(_ completion: @escaping (GetPanelDeviceLoaderAdapter.Result) -> Void) {
            let response = HTTPURLResponse(url: URL(string: "my.url")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            completion(GetDeviceMapper.map(jsonData, response))
        }
    }
}
