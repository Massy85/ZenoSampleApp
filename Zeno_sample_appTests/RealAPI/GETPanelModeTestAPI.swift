//
//  GETPanelModeTestAPI.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import XCTest
@testable import Zeno_sample_app

class GETPanelModeTestAPI: XCTestCase {
    let username: String = "bnfmsm"
    let password: String = "zeno1234"
    
    func test_real_panelModeAPI() {
        let exp = expectation(description: "waiting for completion")
        var sutPanelModeMO: PanelModeMO? = nil
        var sutError: Error? = nil
        
        let sut = PanelModeSPY(username: username, password: password)
        
        sut.completion = { result in
            switch result {
            case .success(let panelModeMO):
                sutPanelModeMO = panelModeMO
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
}

fileprivate class PanelModeSPY {
    let loginLoadAdapter: LoginLoaderAdapter
    var completion: ((Resul) -> Void)?
    
    enum Resul {
        case success(_ panelModeMO: PanelModeMO)
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
                let panelModeLoaderAdapter = GetPanelModeLoaderAdapter(loginMO.token, client: Client())
                panelModeLoaderAdapter.load { result in
                    switch result {
                    case .success(let panelModeMO):
                        self.completion?(.success(panelModeMO))
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
