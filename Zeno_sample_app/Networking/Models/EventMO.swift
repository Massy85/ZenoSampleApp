//
//  EventMO.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import Foundation

public struct EventMO {
    public let result: Bool
    public let code: String
    public let message: String
    public let token: String
    public let panelCode: String
    public let data: [EventDataMO]?
}

extension EventMO: Equatable {
    public static func == (lhs: EventMO, rhs: EventMO) -> Bool {
        guard lhs.result == rhs.result else { return false }
        guard lhs.code == rhs.code else { return false }
        guard lhs.message == rhs.message else { return false }
        guard lhs.token == rhs.token else { return false }
        guard lhs.panelCode == rhs.panelCode else { return false }
        guard lhs.data == rhs.data else { return false }
        return true
    }
}

public struct EventDataMO {
    public let area: String
    public let type: String
    public let id: String
    public let eventType: String
    public let userTrans: String
    public let cidSource: String
    public let time: String
    public let isAlarm: Bool
    public let cidTrans: String
}

extension EventDataMO: Equatable {
    public static func == (lhs: EventDataMO, rhs: EventDataMO) -> Bool {
        guard lhs.type == rhs.type else { return false }
        guard lhs.id == rhs.id else { return false }
        guard lhs.area == rhs.area else { return false }
        guard lhs.eventType == rhs.eventType else { return false }
        guard lhs.userTrans == rhs.userTrans else { return false }
        guard lhs.cidSource == rhs.cidSource else { return false }
        guard lhs.time == rhs.time else { return false }
        guard lhs.isAlarm == rhs.isAlarm else { return false }
        guard lhs.cidTrans == rhs.cidTrans else { return false }
        return true
    }
}
