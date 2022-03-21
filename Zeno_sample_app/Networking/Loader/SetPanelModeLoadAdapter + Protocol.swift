//
//  SetPanelModeLoadAdapter.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import Foundation

//public enum MasterMode: String {
//    case unknow
//    case arm
//    case disarm
//    case home_1
//    case home_2
//    case home_3
//    case home_1_2
//    case home_1_3
//    case home_2_3
//}

internal protocol SetPanelModeLoader {
    typealias Result = Swift.Result<PanelModePostMO, Error>
    
    func load(completion: @escaping (Result) -> Void)
}

internal class SetPanelModeLoaderAdapter {
    
    // MARK: - Properties
    
    private let token: String
    private let mode: ZenoState
    private let area: String
    private let pincode: String
    private let format: String
    private let bypass: String
    private let client: HTTPClient
    
    // MARK: - Error
    
    internal enum Error: Swift.Error {
        case inputData
        case noDataFound
        case panelCommandFault
        case tokenChecking
        case invalidData
        case connectivity
        case errorNotMapped(_ code: String, _  message: String)
    }
    
    // MARK: - Lifecycle
    
    internal init(token: String, mode: ZenoState, area: String = "1", pincode: String = "1234", format: String = "1", bypass: String = "1", client: HTTPClient) {
        self.token = token
        self.mode = mode
        self.area = area
        self.pincode = pincode
        self.format = format
        self.bypass = bypass
        self.client = client
    }
}

// MARK: - SetPanelModeLoader

extension SetPanelModeLoaderAdapter: SetPanelModeLoader {
    internal func load(completion: @escaping (SetPanelModeLoader.Result) -> Void) {
        guard let request = URLRequestsParser.setPanelMode(token, area, mode.rawValue, pincode, format, bypass) else { return }
        
        client.get(from: request) { result in
            switch result {
            case let .success((data, response)):
                completion(PostPanelModeMapper.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

private class PostPanelModeMapper {
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Root
    
    private struct Root: Decodable {
        let code: String
        let token: String
        let panelCode: String
        let message: String
        let result: Bool
        let data: [RootData]?
        
        var item: PanelModePostMO {
            return PanelModePostMO(
                code: code,
                token: token,
                panelCode: panelCode,
                message: message,
                result: result,
                data: data?.compactMap { $0.items }
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
                self.data = try container.decode([RootData].self, forKey: .data)
            }
        }
    }
    
    // MARK: - RootData
    
    private struct RootData: Decodable {
        let type: String?
        let type_no: String?
        let area: String?
        let fault: String
        let zone: String?
        let name: String?
        
        var items: PanelModePostDataMO {
            return PanelModePostDataMO(
                type: type,
                type_no: type_no,
                area: area,
                fault: fault,
                zone: zone,
                name: name
            )
        }
    }
    
    // MARK: - Properties
    
    private static var OK_200: Int { return 200 }
    
    // MARK: - Methods
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) -> SetPanelModeLoader.Result {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data).item else {
            return .failure(SetPanelModeLoaderAdapter.Error.invalidData)
        }
        
        if root.result {
            return .success(root)
        } else {
            switch root.code {
            case "995":
                return .failure(SetPanelModeLoaderAdapter.Error.panelCommandFault)
            case "996":
                return .failure(SetPanelModeLoaderAdapter.Error.panelCommandFault)
            case "999":
                return .failure(SetPanelModeLoaderAdapter.Error.tokenChecking)
            default:
                return .failure(SetPanelModeLoaderAdapter.Error.errorNotMapped(root.code, root.message))
            }
        }
    }
}
