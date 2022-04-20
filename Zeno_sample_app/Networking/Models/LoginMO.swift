//
//  LoginMO.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 16/03/22.
//

import Foundation

public struct LoginMO {
    public let result: Bool
    public let code: String
    public let message: String
    public let token: String
    public let panelCode: String
    public let mac: String?
    public let id: String?
}

extension LoginMO: Equatable {
    public static func == (lhs: LoginMO, rhs: LoginMO) -> Bool {
        guard lhs.result == rhs.result else { return false }
        guard lhs.code == rhs.code else { return false }
        guard lhs.message == rhs.message else { return false }
        guard lhs.token == rhs.token else { return false }
        guard lhs.panelCode == rhs.panelCode else { return false }
        guard lhs.mac == rhs.mac else { return false }
        guard lhs.id == rhs.id else { return false }
        return true
    }
}
