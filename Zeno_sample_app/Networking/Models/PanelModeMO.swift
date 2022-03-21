//
//  PanelModeMO.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import Foundation

public enum ZenoState {
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
    public let mode: ZenoState?
    public let area: String?
    public let burglar: Bool?
}
