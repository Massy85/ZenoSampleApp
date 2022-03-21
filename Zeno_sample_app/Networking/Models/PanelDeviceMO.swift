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
