//
//  GetEventsLoaderAdapter + Protocol.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import Foundation

internal enum EventType: String {
    case media = "media"
    case alarm = "alarm"
}

internal protocol EventsLoader {
    typealias Result = Swift.Result<EventMO, Error>
    
    func load(completion: @escaping (Result) -> Void)
}

internal class GetEventsLoaderAdapter {
    // MARK: - Properties
    
    private let token: String
    private let numberOfEvents: String
    private let type: EventType?
    private let eventDate: String?
    private let client: HTTPClient
    
    // MARK: - Error
    
    internal enum Error: Swift.Error {
        case tokenChecking
        case noDataFound
        case connectivity
        case invalidData
        case errorNotMapped(_ code: String, _  message: String)
    }
    
    // MARK: - Lifecycle
    
    internal init(token: String, events: String = "10000", type: EventType? = nil, date: String? = nil, client: HTTPClient) {
        self.token = token
        self.numberOfEvents = events
        self.type = type
        self.eventDate = date
        self.client = client
    }
}

// MARK: - EventsLoader

extension GetEventsLoaderAdapter: EventsLoader {
    internal func load(completion: @escaping (EventsLoader.Result) -> Void) {
        guard let request = URLRequestsParser.getEvents(token, numberOfEvents, type?.rawValue, eventDate) else { return }
        
        client.get(from: request) { result in
            switch result {
            case let .success((data, response)):
                completion(EventsMapper.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

internal class EventsMapper {
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
        
        var item: EventMO {
            return EventMO(
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
        let area: String
        let type: String
        let id: String
        let eventType: String
        let userTrans: String
        let cidSource: String
        let time: String
        let isAlarm: Bool
        let cidTrans: String
        
        var item: EventDataMO {
            return EventDataMO(
                area: area,
                type: type,
                id: id,
                eventType: eventType,
                userTrans: userTrans,
                cidSource: cidSource,
                time: time,
                isAlarm: isAlarm,
                cidTrans: cidTrans
            )
        }
        
        private enum CodingKeys: String, CodingKey {
            case area
            case type
            case id
            case eventType = "event_type"
            case userTrans = "user_trans"
            case cidSource = "cid_source"
            case time
            case isAlarm = "is_alarm"
            case cidTrans = "cid_trans"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.area = try container.decode(String.self, forKey: .area)
            self.type = try container.decode(String.self, forKey: .type)
            self.id = try container.decode(String.self, forKey: .id)
            self.eventType = try container.decode(String.self, forKey: .eventType)
            self.userTrans = try container.decode(String.self, forKey: .userTrans)
            self.cidSource = try container.decode(String.self, forKey: .cidSource)
            self.time = try container.decode(String.self, forKey: .time)
            self.isAlarm = try container.decode(Bool.self, forKey: .isAlarm)
            self.cidTrans = try container.decode(String.self, forKey: .cidTrans)
        }
    }
    
    // MARK: - Properties
    
    private static var OK_200: Int { return 200 }
    
    // MARK: - Methods
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) -> EventsLoader.Result {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data).item else {
            return .failure(GetEventsLoaderAdapter.Error.invalidData)
        }
        
        if root.result {
            return .success(root)
        } else {
            switch root.code {
            case "999":
                return .failure(GetEventsLoaderAdapter.Error.tokenChecking)
            case "998":
                return .failure(GetEventsLoaderAdapter.Error.noDataFound)
            default:
                return .failure(GetEventsLoaderAdapter.Error.errorNotMapped(root.code, root.message))
            }
        }
    }
}
