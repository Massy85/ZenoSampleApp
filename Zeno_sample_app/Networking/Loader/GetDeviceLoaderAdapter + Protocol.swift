//
//  GetDeviceLoaderAdapter + Protocol.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import Foundation

internal protocol DeviceLoader {
    typealias Result = Swift.Result<PanelDeviceMO, Error>
    
    func load(completion: @escaping (Result) -> Void)
}


internal class GetPanelDeviceLoaderAdapter {
    // MARK: - Properties
    
    private let token: String
    private let client: HTTPClient
    
    // MARK: - Error
    
    internal enum Error: Swift.Error {
        case tokenCheckingError
        case invalidData
        case connectivity
        case errorNotMapped(_ code: String, _  message: String)
    }
    
    // MARK: - Lifecycle
    
    internal init(_ token: String, _ client: HTTPClient) {
        self.token = token
        self.client = client
    }
}

// MARK: - DeviceLoader

extension GetPanelDeviceLoaderAdapter: DeviceLoader {
    internal func load(completion: @escaping (DeviceLoader.Result) -> Void) {
        guard let request = URLRequestsParser.getPanelDevice(token) else { return }
        
        client.get(from: request) { result in
            switch result {
            case let .success((data, response)):
                completion(GetDeviceMapper.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

fileprivate class GetDeviceMapper {
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Root
    
    private struct Root: Decodable {
        let result: Bool
        let code: String
        let message: String
        let token: String
        let panelCode: String
        let data: [RootData]?
        
        var item: PanelDeviceMO {
            return PanelDeviceMO(
                result: result,
                code: code,
                message: message,
                token: token,
                panelCode: panelCode,
                data: data?.compactMap { $0.item }
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
        let address: String?
        let group: String?
        let status: String?
        let id: String?
        let typeNo: String?
        let bypass: String?
        let rssi: String?
        let statusOpen: [String]?
        let statusFault: [String]?
        let deviceCategory: String?
        let attr: String?
        let type: String?
        let area: String?
        
        var item: PanelDeviceDataMO {
            return PanelDeviceDataMO(
                address: address,
                group: group,
                status: status,
                id: id,
                typeNo: typeNo,
                bypass: bypass,
                rssi: rssi,
                statusOpen: statusOpen,
                statusFault: statusFault,
                deviceCategory: deviceCategory,
                attr: attr,
                type: type,
                area: area
            )
        }
        
        private enum CodingKeys: String, CodingKey {
            case address
            case group = "device_group"
            case status = "status1"
            case id = "device_id"
            case typeNo = "type_no"
            case bypass = "bypass"
            case rssi
            case statusOpen = "status_open"
            case statusFault = "status_fault"
            case deviceCategory = "device_category"
            case attr
            case type = "type"
            case area
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.address = try container.decode(String.self, forKey: .address)
            self.group = try container.decode(String.self, forKey: .group)
            self.status = try container.decode(String.self, forKey: .status)
            self.id = try container.decode(String.self, forKey: .id)
            self.typeNo = try container.decode(String.self, forKey: .typeNo)
            self.bypass = try container.decode(String.self, forKey: .bypass)
            self.rssi = try container.decode(String.self, forKey: .rssi)
            self.deviceCategory = try container.decode(String.self, forKey: .deviceCategory)
            self.attr = try container.decode(String.self, forKey: .attr)
            self.type = try container.decode(String.self, forKey: .type)
            self.area = try container.decode(String.self, forKey: .area)
            self.statusOpen = try container.decode([String].self, forKey: .statusOpen)
            self.statusFault = try container.decode([String].self, forKey: .statusFault)
        }
    }
    
    // MARK: - Properties
    
    private static var OK_200: Int { return 200 }
    
    // MARK: - Methods
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) -> DeviceLoader.Result {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data).item else {
            return .failure(GetPanelDeviceLoaderAdapter.Error.invalidData)
        }
        
        if root.result {
            return .success(root)
        } else {
            switch root.code {
            case "999":
                return .failure(GetPanelDeviceLoaderAdapter.Error.tokenCheckingError)
            default:
                return .failure(GetPanelDeviceLoaderAdapter.Error.errorNotMapped(root.code, root.message))
            }
        }
    }
}
