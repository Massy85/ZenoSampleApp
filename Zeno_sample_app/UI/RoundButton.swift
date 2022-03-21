//
//  RoundButton.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 17/03/22.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = frame.height / 2
    }
    
    var isActive: Bool = false
    
    var isPressed: Bool = false {
        didSet {
            isActive = isPressed
        }
    }
    
//    {
//        didSet {
//            if isActive {
//                backgroundColor = .orange
//            } else {
//                backgroundColor = .clear
//            }
//        }
//    }
}
