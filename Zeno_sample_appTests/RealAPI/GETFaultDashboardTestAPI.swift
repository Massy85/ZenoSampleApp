//
//  GETFaultDashboardTestAPI.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 08/04/22.
//

import XCTest
@testable import Zeno_sample_app

class GETFaultDashboardTestAPI: XCTestCase {
    let credentilas: Credentials = .zenoProMassimiliano
    
    var username: String {
        credentilas.credentials.username
    }
    
    var password: String {
        credentilas.credentials.password
    }
    
    func test_real_faultDashboardAPI() {
        let exp = expectation(description: "waiting for completion")
        var sutDashboardMO: DashboardMO? = nil
        var sutError: Error? = nil
        
        let sut = FaultSPY(username: username, password: password)
        
        sut.completion = { result in
            switch result {
            case .success(let dashboardMO):
                sutDashboardMO = dashboardMO
            case .failure(let error):
                sutError = error
            }
            exp.fulfill()
        }
        
        sut.perform()
        
        wait(for: [exp], timeout: 10)
        XCTAssertNotNil(sutDashboardMO)
        XCTAssertNil(sutError)
    }
    
    // MARK: - Helper
    
    private class FaultSPY {
        let loginLoadAdapter: LoginLoaderAdapter
        var completion: ((Resul) -> Void)?
        
        enum Resul {
            case success(_ dashboardMO: DashboardMO)
            case failure(_ error: Error)
        }
        
        init(username: String, password: String) {
            loginLoadAdapter = LoginLoaderAdapter(username: username, password: password, client: Client())
        }
        
        func perform() {
            loginLoadAdapter.load { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let loginMO):
                    let faultDashboardAdapter = GetFaultDashboardAdapter(token: loginMO.token, client: Client())
                    faultDashboardAdapter.load { result in
                        switch result {
                        case .success(let dashboardMO):
                            self.completion?(.success(dashboardMO))
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
