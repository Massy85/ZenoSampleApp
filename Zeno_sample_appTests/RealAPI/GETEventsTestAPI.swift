//
//  GETEventsTestAPI.swift
//  Zeno_sample_appTests
//
//  Created by Massimiliano Bonafede on 17/03/22.
//

import XCTest
@testable import Zeno_sample_app


class GETEventsTestAPI: XCTestCase {
    let username: String = "bnfmsm"
    let password: String = "zeno1234"
    
    func test_real_eventsAPI() {
        let exp = expectation(description: "waiting for completion")
        var sutEventsMO: EventMO? = nil
        var sutError: Error? = nil
        
        let sut = EventsSPY(username: username, password: password)
        
        sut.completion = { result in
            switch result {
            case .success(let eventMO):
                sutEventsMO = eventMO
            case .failure(let error):
                sutError = error
            }
            exp.fulfill()
        }
        
        sut.perform()
        
        
        wait(for: [exp], timeout: 10)
        XCTAssertNotNil(sutEventsMO)
        XCTAssertNil(sutError)
    }

}

fileprivate class EventsSPY {
    let loginLoadAdapter: LoginLoaderAdapter
    var completion: ((Resul) -> Void)?
    
    enum Resul {
        case success(_ panelModeMO: EventMO)
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
                let eventsLoaderAdapter = GetEventsLoaderAdapter(token: loginMO.token, client: Client())
                eventsLoaderAdapter.load { result in
                    switch result {
                    case .success(let eventsMO):
                        self.completion?(.success(eventsMO))
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
