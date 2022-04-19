//
//  DashboardMO.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 19/04/22.
//

import Foundation

public struct DashboardMO {
    public let result: Bool
    public let code: String
    public let message: String
    public let token: String
    public let panelCode: String
    public let panelFaultsNumber: Int
    public let panelFaults: [String]
    public let deviceFaultsNumber: Int
    public let deviceFaults: [String]
    public let totalDevice: Int
    public let dcFaultsNumber: Int
    public let dcFaults: [String]
    public let totalDc: Int
}
