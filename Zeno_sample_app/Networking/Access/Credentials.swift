//
//  Credentials.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 19/04/22.
//

import Foundation

public enum Credentials {
    case zenoMassimiliano
    case zenoProMassimiliano
    case zenoProOffice
    case zenoPerracchio
    
    var credentials: (username: String, password: String) {
        switch self {
        case .zenoMassimiliano:
            return ("bnfmsm", "zeno1234")
        case .zenoProMassimiliano:
            return ("zenopromax", "zenopromax22")
        case .zenoProOffice:
            return ("zenoprolab", "zenoprolab22")
        case .zenoPerracchio:
            return ("mlpro2", "mlpro21")
        }
    }
}
