//
//  PanelModeMO.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import Foundation

public enum ZenoState: String {
    case unowned
    case arm
    case disarm
    case home_1
    case home_2
    case home_3
    
    init?(mode: String?) {
        switch mode {
        case "arm":
            self = .arm
        case "disarm":
            self = .disarm
        case "home_1":
            self = .home_1
        case "home_2":
            self = .home_2
        case "home_3":
            self = .home_3
        default: return nil
        }
    }
}

public struct PanelModeMO {
    public let result: Bool
    public let code: String
    public let message: String
    public let token: String
    public let panelCode: String
    public let areaName: String?
    public let mode: ZenoState
    public let area: String
    public let burglar: Bool
}

extension PanelModeMO: Equatable {
    public static func == (lhs: PanelModeMO, rhs: PanelModeMO) -> Bool {
        guard lhs.result == rhs.result else { return false }
        guard lhs.code == rhs.code else { return false }
        guard lhs.message == rhs.message else { return false }
        guard lhs.token == rhs.token else { return false }
        guard lhs.panelCode == rhs.panelCode else { return false }
        guard lhs.areaName == rhs.areaName else { return false }
        guard lhs.mode == rhs.mode else { return false }
        guard lhs.area == rhs.area else { return false }
        guard lhs.burglar == rhs.burglar else { return false }
        return true
    }
}
