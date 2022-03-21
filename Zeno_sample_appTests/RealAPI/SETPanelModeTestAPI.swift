//
//  SETPanelModeTestAPI.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 17/03/22.
//

import XCTest
@testable import Zeno_sample_app

class SETPanelModeTestAPI: XCTestCase {
    let username: String = "bnfmsm"
    let password: String = "zeno1234"
    
    func test_real_set_panelModeAPI() {
        let exp = expectation(description: "waiting for completion")
        var sutPanelModeMO: PanelModePostMO? = nil
        var sutError: Error? = nil
        
        let sut = SetPanelModeSPY(username: username, password: password)
        
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
    

}


fileprivate class SetPanelModeSPY {
    let loginLoadAdapter: LoginLoaderAdapter
    var completion: ((Resul) -> Void)?
    
    enum Resul {
        case success(_ panelModePostMO: PanelModePostMO)
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
                let setPanelModeLoaderAdapter = SetPanelModeLoaderAdapter(token: loginMO.token, mode: .arm, client: Client())
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
