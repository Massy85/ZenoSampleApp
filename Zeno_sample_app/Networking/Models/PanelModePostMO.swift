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

public struct PanelModePostDataMO {
    public let type: String?
    public let type_no: String?
    public let area: String?
    public let fault: String?
    public let zone: String?
    public let name: String?
}
