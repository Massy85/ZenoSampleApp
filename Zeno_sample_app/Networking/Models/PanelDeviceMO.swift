//
//  DeviceMO.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import Foundation

public struct PanelDeviceMO {
    public let result: Bool
    public let code: String
    public let message: String
    public let token: String
    public let panelCode: String
    public let data: [PanelDeviceDataMO]?
}

extension PanelDeviceMO: Equatable {
    public static func == (lhs: PanelDeviceMO, rhs: PanelDeviceMO) -> Bool {
        guard lhs.result == rhs.result else { return false }
        guard lhs.code == rhs.code else { return false }
        guard lhs.message == rhs.message else { return false }
        guard lhs.token == rhs.token else { return false }
        guard lhs.panelCode == rhs.panelCode else { return false }
        guard lhs.data == rhs.data else { return false }
        return true
    }
}

public struct PanelDeviceDataMO {
    public let address: String?
    public let group: String?
    public let status: String?
    public let id: String?
    public let typeNo: String?
    public let bypass: String?
    public let rssi: String?
    public let statusOpen: [String]?
    public let statusFault: [String]?
    public let deviceCategory: String?
    public let attr: String?
    public let type: String?
    public let area: String?
}

extension PanelDeviceDataMO: Equatable {
    public static func == (lhs: PanelDeviceDataMO, rhs: PanelDeviceDataMO) -> Bool {
        guard (lhs.address != nil) == (rhs.address != nil) else { return false }
        guard (lhs.group != nil) == (rhs.group != nil) else { return false }
        guard (lhs.status != nil) == (rhs.status != nil) else { return false }
        guard (lhs.id != nil) == (rhs.id != nil) else { return false }
        guard (lhs.typeNo != nil) == (rhs.typeNo != nil) else { return false }
        guard (lhs.bypass != nil) == (rhs.bypass != nil) else { return false }
        guard (lhs.statusOpen != nil) == (rhs.statusOpen != nil) else { return false }
        guard (lhs.statusFault != nil) == (rhs.statusFault != nil) else { return false }
        guard (lhs.deviceCategory != nil) == (rhs.deviceCategory != nil) else { return false }
        guard (lhs.attr != nil) == (rhs.attr != nil) else { return false }
        guard (lhs.type != nil) == (rhs.type != nil) else { return false }
        guard (lhs.area != nil) == (rhs.area != nil) else { return false }
        guard (lhs.rssi != nil) == (rhs.rssi != nil) else { return false }
        return true
    }
}
