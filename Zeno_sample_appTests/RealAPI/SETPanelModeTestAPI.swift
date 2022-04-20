//
//  SETPanelModeTestAPI.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 17/03/22.
//

import XCTest
@testable import Zeno_sample_app

class SETPanelModeTestAPI: XCTestCase {
    let credentilas: Credentials = .zenoProMassimiliano
    
    var username: String {
        credentilas.credentials.username
    }
    
    var password: String {
        credentilas.credentials.password
    }
    
    func test_real_set_panelModeAPI_arm_with_bypass_1() {
        let exp = expectation(description: "waiting for completion")
        var sutPanelModeMO: PanelModePostMO? = nil
        var sutError: Error? = nil
        
        let sut = SetPanelModeSPY(username: username, password: password, bybass: .one)
        
        sut.completion = { result in
            switch result {
            case .success(let panelModePostMO):
                sutPanelModeMO = panelModePostMO
            case .failure(let error):
                sutError = error
            }
            exp.fulfill()
        }
        
        sut.perform()
        
        wait(for: [exp], timeout: 10)
        XCTAssertNotNil(sutPanelModeMO)
        XCTAssertNil(sutError)
    }
    
    func test_real_set_panelModeAPI_arm_with_bypass_0() {
        let exp = expectation(description: "waiting for completion")
        var sutPanelModeMO: PanelModePostMO? = nil
        var sutError: Error? = nil
        
        let sut = SetPanelModeSPY(username: username, password: password, bybass: .zero)
        
        sut.completion = { result in
            switch result {
            case .success(let panelModePostMO):
                sutPanelModeMO = panelModePostMO
            case .failure(let error):
                sutError = error
            }
            exp.fulfill()
        }
        
        sut.perform()
        
        wait(for: [exp], timeout: 10)
        XCTAssertNotNil(sutError)
        XCTAssertNil(sutPanelModeMO)
    }
    
    func test_reset() {
        let exp = expectation(description: "waiting for completion")
        var sutPanelModeMO: PanelModePostMO? = nil
        var sutError: Error? = nil
        
        let sut = SetPanelModeSPY(username: username, password: password, bybass: .one, mode: .disarm)
        
        sut.completion = { result in
            switch result {
            case .success(let panelModePostMO):
                sutPanelModeMO = panelModePostMO
            case .failure(let error):
                sutError = error
            }
            exp.fulfill()
        }
        
        sut.perform()
        
        wait(for: [exp], timeout: 10)
        XCTAssertNotNil(sutPanelModeMO)
        XCTAssertNil(sutError)
    }
    
    // MARK: - Helper

    private class SetPanelModeSPY {
        let loginLoadAdapter: LoginLoaderAdapter
        var completion: ((Resul) -> Void)?
        private let bypass: ByPass
        private let mode: ZenoState
        
        enum ByPass: String {
            case zero = "0"
            case one = "1"
        }
        
        enum Resul {
            case success(_ panelModePostMO: PanelModePostMO)
            case failure(_ error: Error)
        }
        
        init(username: String, password: String, bybass: ByPass, mode: ZenoState = .arm) {
            self.bypass = bybass
            self.mode = mode
            loginLoadAdapter = LoginLoaderAdapter(username: username, password: password, client: Client())
        }
        
        func perform() {
            loginLoadAdapter.load { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let loginMO):
                    let setPanelModeLoaderAdapter = SetPanelModeLoaderAdapter(token: loginMO.token, mode: self.mode, bypass: self.bypass.rawValue, client: Client())
                    setPanelModeLoaderAdapter.load { result in
                        switch result {
                        case .success(let setPanelModeMO):
                            self.completion?(.success(setPanelModeMO))
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
