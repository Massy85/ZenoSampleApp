//
//  GetPanelModeLoader.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import Foundation

internal protocol GetPanelModeLoader {
    typealias Result = Swift.Result<PanelModeMO, Error>
    
    func load(completion: @escaping (Result) -> Void)
}

internal class GetPanelModeLoaderAdapter {
    
    // MARK: - Properties
    
    private let token: String
    private let client: HTTPClient
    
    // MARK: - Error
    
    internal enum Error: Swift.Error {
        case tokenCheckingError
        case noDataFoundError
        case invalidData
        case connectivity
        case errorNotMapped(_ code: String, _  message: String)
    }
    
    // MARK: - Lifecycle
    
    internal init(_ token: String, client: HTTPClient) {
        self.token = token
        self.client = client
    }
}

// MARK: - GetPanelModeLoader

extension GetPanelModeLoaderAdapter: GetPanelModeLoader {
    internal func load(completion: @escaping (GetPanelModeLoader.Result) -> Void) {
        guard let request = URLRequestsParser.getPanelMode(token) else { return }
        
        client.get(from: request) { result in
            switch result {
            case let .success((data, response)):
                completion(GetPanelModeMapper.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}


internal class GetPanelModeMapper {
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Root
    
    private struct Root: Decodable {
        public let result: Bool
        public let code: String
        public let message: String
        public let token: String
        public let panelCode: String
        public let data: RootData
        
        var item: PanelModeMO {
            return PanelModeMO(
                result: result,
                code: code,
                message: message,
                token: token,
                panelCode: panelCode,
                areaName: data.areaName,
                mode: ZenoState.init(mode: data.mode) ?? .unowned,
                area: data.area,
                burglar: data.burglar
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
            
            if let _  = try? container.decode(String.self, forKey: .data) {
                self.data = RootData()
            } else {
                self.data = try container.decode([RootData].self, forKey: .data).first ?? RootData()
            }
        }
    }
    
    // MARK: - RootData
    
    private struct RootData: Decodable {
        let areaName: String
        let mode: String
        let area: String
        let burglar: Bool
        
        init() {
            self.areaName = ""
            self.mode = ""
            self.area = ""
            self.burglar = false
        }
        
        private enum CodingKeys: String, CodingKey {
            case mode
            case area
            case burglar
            case areaName = "area_name"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.areaName = try container.decode(String.self, forKey: .areaName)
            self.mode = try container.decode(String.self, forKey: .mode)
            self.area = try container.decode(String.self, forKey: .area)
            self.burglar = try container.decode(Bool.self, forKey: .burglar)
        }
    }
    
    // MARK: - Properties
    
    private static var OK_200: Int { return 200 }
    
    // MARK: - Methods
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) -> GetPanelModeLoader.Result {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data).item else {
            return .failure(GetPanelModeLoaderAdapter.Error.invalidData)
        }
        
        if root.result {
            return .success(root)
        } else {
            switch root.code {
            case "998":
                return .failure(GetPanelModeLoaderAdapter.Error.noDataFoundError)
            case "999":
                return .failure(GetPanelModeLoaderAdapter.Error.tokenCheckingError)
            default:
                return .failure(GetPanelModeLoaderAdapter.Error.errorNotMapped(root.code, root.message))
            }
        }
    }
}
