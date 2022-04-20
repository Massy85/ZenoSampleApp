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

extension DashboardMO: Equatable {
    public static func == (lhs: DashboardMO, rhs: DashboardMO) -> Bool {
        guard lhs.result == rhs.result else { return false }
        guard lhs.code == rhs.code else { return false }
        guard lhs.message == rhs.message else { return false }
        guard lhs.token == rhs.token else { return false }
        guard lhs.panelCode == rhs.panelCode else { return false }
        guard lhs.panelFaultsNumber == rhs.panelFaultsNumber else { return false }
        guard lhs.panelFaults == rhs.panelFaults else { return false }
        guard lhs.deviceFaultsNumber == rhs.deviceFaultsNumber else { return false }
        guard lhs.deviceFaults == rhs.deviceFaults else { return false }
        guard lhs.totalDevice == rhs.totalDevice else { return false }
        guard lhs.dcFaultsNumber == rhs.dcFaultsNumber else { return false }
        guard lhs.dcFaults == rhs.dcFaults else { return false }
        guard lhs.totalDc == rhs.totalDc else { return false }
        return true
    }
}
