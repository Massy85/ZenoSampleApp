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
