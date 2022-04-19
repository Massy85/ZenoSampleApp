//
//  GetPanelDeviceTestAPI.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 17/03/22.
//

import XCTest
@testable import Zeno_sample_app

class GETPanelDeviceTestAPI: XCTestCase {
    let credentilas: Credentials = .zenoProMassimiliano
    
    var username: String {
        credentilas.credentials.username
    }
    
    var password: String {
        credentilas.credentials.password
    }
    
    func test_get_panelDeviceAPI() {
        let exp = expectation(description: "waiting for completion")
        var sutPanelDeviceMO: PanelDeviceMO? = nil
        var sutError: Error? = nil
        
        let sut = PanelDeviceSPY(username: username, password: password)
        
        sut.completion = { result in
            switch result {
            case .success(let panelDeviceMO):
                sutPanelDeviceMO = panelDeviceMO
            case .failure(let error):
                sutError = error
            }
            exp.fulfill()
        }
        
        sut.perform()
        
        wait(for: [exp], timeout: 10)
        XCTAssertNotNil(sutPanelDeviceMO)
        XCTAssertNil(sutError)
    }
    
    // MARK: - Helper

    private class PanelDeviceSPY {
        let loginLoadAdapter: LoginLoaderAdapter
        var completion: ((Resul) -> Void)?
        
        enum Resul {
            case success(_ panelDeviceMO: PanelDeviceMO)
            case failure(_ error: Error)
        }
        
        init(username: String, password: String) {
            loginLoadAdapter = LoginLoaderAdapter(username: username, password: password, client: Client())
        }
        
        func perform() {
            loginLoadAdapter.load { result in
                switch result {
                case.success(let loginMO):
                    let panelDeviceLoader = GetPanelDeviceLoaderAdapter(loginMO.token, Client())
                    panelDeviceLoader.load { result in
                        switch result {
                        case .success(let panelDeviceMO):
                            self.completion?(.success(panelDeviceMO))
                        case .failure(let error):
                            self.completion?(.failure(error))
                        }
                    }
                case .failure(let error):
                    self.completion?(.failure(error))
                }
            }
        }
    }
}
