//
//  LoginTestAPI.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import XCTest
@testable import Zeno_sample_app

class LoginTestAPI: XCTestCase {
    let credentilas: Credentials = .zenoProMassimiliano
    
    var username: String {
        credentilas.credentials.username
    }
    
    var password: String {
        credentilas.credentials.password
    }
    
    func test_real_loginAPI() {
        let exp = expectation(description: "waiting for completion")
        var sutLoginMO: LoginMO? = nil
        var sutErrorLogin: Error? = nil
        
        let sut = LoginSPY(username: username, password: password)
        
        sut.completion = { result in
            switch result {
            case .success(let loginMO):
                sutLoginMO = loginMO
            case .failure(let error):
                sutErrorLogin = error
            }
            exp.fulfill()
        }
        
        sut.perform()
        
        wait(for: [exp], timeout: 10)
        XCTAssertNotNil(sutLoginMO)
        XCTAssertNil(sutErrorLogin)
    }
    
    // MARK: - Helper

    private class LoginSPY {
        let loginLoadAdapter: LoginLoaderAdapter
        var completion: ((Resul) -> Void)?
        
        enum Resul {
            case success(_ loginMO: LoginMO)
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
                    self.completion?(.success(loginMO))
                case .failure(let error):
                    self.completion?(.failure(error))
                }
            }
        }
    }
}
