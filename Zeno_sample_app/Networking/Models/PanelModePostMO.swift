//
//  PanelModePostMO.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import Foundation

public struct PanelModePostMO {
    public let code: String
    public let token: String
    public let panelCode: String
    public let message: String
    public let result: Bool
    public let data: [PanelModePostDataMO]?
}

extension PanelModePostMO: Equatable {
    public static func == (lhs: PanelModePostMO, rhs: PanelModePostMO) -> Bool {
        guard lhs.result == rhs.result else { return false }
        guard lhs.code == rhs.code else { return false }
        guard lhs.message == rhs.message else { return false }
        guard lhs.token == rhs.token else { return false }
        guard lhs.panelCode == rhs.panelCode else { return false }
        guard lhs.data == rhs.data else { return false }
        return true
    }
}

public struct PanelModePostDataMO {
    public let type: String?
    public let type_no: String?
    public let area: String?
    public let fault: String?
    public let zone: String?
    public let name: String?
}

extension PanelModePostDataMO: Equatable {
    public static func == (lhs: PanelModePostDataMO, rhs: PanelModePostDataMO) -> Bool {
        guard lhs.type == rhs.type else { return false }
        guard lhs.type_no == rhs.type_no else { return false }
        guard lhs.area == rhs.area else { return false }
        guard lhs.fault == rhs.fault else { return false }
        guard lhs.zone == rhs.zone else { return false }
        guard lhs.name == rhs.name else { return false }
        return true
    }
}
