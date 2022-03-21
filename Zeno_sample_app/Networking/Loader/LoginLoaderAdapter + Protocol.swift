//
//  LoginLoaderAdapter + Protocol.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import Foundation

internal protocol LoginLoader {
    typealias Result = Swift.Result<LoginMO, Error>
    
    func load(completion: @escaping (Result) -> Void)
}

internal class LoginLoaderAdapter {
    // MARK: - Properties

    private let username: String
    private let password: String
    private let client: HTTPClient
    
    // MARK: - Error

    internal enum Error: Swift.Error {
        case inputDataError
        case loginBlockedError
        case loginPasswordError
        case loginAccountError
        case panelSuspendError
        case connectivity
        case invalidData
        case errorNotMapped(_ code: String, _  message: String)
    }
    
    // MARK: - Lifecycle

    internal init(username: String, password: String, client: HTTPClient) {
        self.username = username
        self.password = password
        self.client = client
    }
}

// MARK: - LoginLoader

extension LoginLoaderAdapter: LoginLoader {
    internal func load(completion: @escaping (LoginLoader.Result) -> Void) {
        guard let request = URLRequestsParser.login(username, password) else { return }
        client.get(from: request) { result in
            switch result {
            case let .success((data, response)):
                completion(LoginMapper.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

fileprivate class LoginMapper {
    // MARK: - Lifecycle

    private init() {}
    
    // MARK: - Root

    private struct Root: Decodable {
        let result: Bool
        let code: String
        let message: String
        let token: String
        let panelCode: String
        let data: RootData?
        
        var item: LoginMO {
            return LoginMO(
                result: result,
                code: code,
                message: message,
                token: token,
                panelCode: panelCode,
                mac: data?.mac,
                id: data?.id
            )
        }
        
        private enum CodingKeys: String, CodingKey {
            case result
            case code
            case message
            case token
            case data
            case panelCode
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.result = try container.decode(Bool.self, forKey: .result)
            self.code = try container.decode(String.self, forKey: .code)
            self.message = try container.decode(String.self, forKey: .message)
            self.token = try container.decode(String.self, forKey: .token)
            self.panelCode = try container.decode(String.self, forKey: .panelCode)
            
            if let _  = try? container.decodeIfPresent(String.self, forKey: .data) {
                self.data = nil
            } else {
                self.data = try container.decode(RootData.self, forKey: .data)
            }
        }
        
    }
    
    // MARK: - RootData

    private struct RootData: Decodable {
        let mac: String
        let id: String
    }
    
    // MARK: - Properties
    
    private static var OK_200: Int { return 200 }
    
    // MARK: - Methods

    internal static func map(_ data: Data, _ response: HTTPURLResponse) -> LoginLoader.Result {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data).item else {
            return .failure(LoginLoaderAdapter.Error.invalidData)
        }
                
        if root.result {
            return .success(root)
        } else {
            switch root.code {
            case "001":
                return .failure(LoginLoaderAdapter.Error.inputDataError)
            case "018":
                return .failure(LoginLoaderAdapter.Error.loginBlockedError)
            case "011":
                return .failure(LoginLoaderAdapter.Error.loginPasswordError)
            case "010":
                return .failure(LoginLoaderAdapter.Error.loginAccountError)
            case "040":
                return .failure(LoginLoaderAdapter.Error.panelSuspendError)
            default: return .failure(LoginLoaderAdapter.Error.errorNotMapped(root.code, root.message))
            }
        }
    }
}
