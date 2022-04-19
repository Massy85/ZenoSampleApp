//
//  GetFaultDashboardAdapter + Protocol.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 08/04/22.
//

import Foundation

internal protocol FaultDashboardLoader {
    typealias Result = Swift.Result<DashboardMO, Error>
    
    func load(completion: @escaping (Result) -> Void)
}

internal class GetFaultDashboardAdapter {
    // MARK: - Properties

    private let token: String
    private let client: HTTPClient
    
    // MARK: - Error
    
    internal enum Error: Swift.Error {
        case connectivity
        case errorNotMapped(_ code: String, _  message: String)
    }
    
    internal init(token: String, client: HTTPClient) {
        self.token = token
        self.client = client
    }
}

extension GetFaultDashboardAdapter: FaultDashboardLoader {
    func load(completion: @escaping (FaultDashboardLoader.Result) -> Void) {
        guard let request = URLRequestsParser.getFaultDashboard(token) else { return }
        
        client.get(from: request) { result in
            switch result {
            case let .success((data, response)):
                completion(DashboardMapper.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

fileprivate class DashboardMapper {
    // MARK: - Lifecycle

    private init() {}
    
    // MARK: - Root
    
    private struct Root: Decodable {
        let result: Bool
        let code: String
        let message: String
        let token: String
        let panelCode: String
        let data: RootData
        
        var item: DashboardMO {
            return DashboardMO(
                result: result,
                code: code,
                message: message,
                token: token,
                panelCode: panelCode,
                panelFaultsNumber: data.panel.quantity,
                panelFaults: data.panel.detail,
                deviceFaultsNumber: data.device.quantity,
                deviceFaults: data.device.detail,
                totalDevice: data.device.total,
                dcFaultsNumber: data.dc.quantity,
                dcFaults: data.dc.detail,
                totalDc: data.dc.total
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
            self.data = try container.decode(RootData.self, forKey: .data)
        }
    }
    
    // MARK: - RootData
    
    private struct RootData: Decodable {
        let panel: RootCommon
        let device: RootCommon
        let dc: RootCommon
    }

    // MARK: - RootCommon
    
    private struct RootCommon: Decodable {
        let detail: [String]
        let quantity: Int
        let total: Int
        
        private enum CodingKeys: String, CodingKey {
            case detail
            case quantity = "fault_quantity"
            case total
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let detail = try container.decodeIfPresent([String].self, forKey: .detail) {
                self.detail = detail
            } else {
                self.detail = []
            }
            
            if let quantity = try container.decodeIfPresent(String.self, forKey: .quantity) {
                self.quantity = Int(quantity) ?? 0
            } else {
                self.quantity = 0
            }
            
            if let total = try container.decodeIfPresent(String.self, forKey: .total) {
                self.total = Int(total) ?? 0
            } else {
                self.total = 0
            }
        }
    }
    
    // MARK: - Properties
    
    private static var OK_200: Int { return 200 }
    
    // MARK: - Methods
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) -> FaultDashboardLoader.Result {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data).item else {
            return .failure(GetEventsLoaderAdapter.Error.invalidData)
        }
        
        if root.result {
            return .success(root)
        } else {
            return .failure(GetFaultDashboardAdapter.Error.errorNotMapped(root.code, root.message))
        }
    }
}

/*
 
 {
   "panelCode" : "",
   "result" : true,
   "data" : {
     "panel" : {
       "detail" : [
         "No SIM Card",
         "No Segnale GSM"
       ],
       "fault_quantity" : "2"
     },
     "device" : {
       "detail" : [

       ],
       "fault_quantity" : "0",
       "total" : "0"
     },
     "dc" : {
       "detail" : [

       ],
       "fault_quantity" : "0",
       "total" : "0"
     }
   },
   "code" : "000",
   "message" : "OK!",
   "token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJjbGltYXgtbXF0dC1hcGkiLCJsb2dnaW4iOnsidXNlcklkIjoxMjI5NCwiaWQiOiJ6ZW5vcHJvbGFiIiwibWFjIjoiMDA6MWQ6OTQ6MTI6NDc6Y2QiLCJtYXN0ZXIiOjEsImFnZW50IjpmYWxzZSwiaGEiOmZhbHNlLCJ4bWxWZXJzaW9uIjozLCJpc0luc3RhbGxlciI6ZmFsc2V9LCJpYXQiOjE2NDk0MjI5NDV9.Z4ui5cHBcHdLvRTJbComqF9-vDkWYFqODVfu4B81wtI"
 }
 
 */
