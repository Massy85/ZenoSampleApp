//
//  PartializationView.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 17/03/22.
//

import UIKit

class PartializationView: UIView {
//    private let image = UIImage(named: "check")
    private let image = UIImage(systemName: "plus.circle")
    
    private let userDefault = UserDefaults.standard
    
    private let aButton = UIButton()
    private var aPressed: Bool = false
    
    private let bButton = UIButton()
    private var bPressed: Bool = false
    
    private let cButton = UIButton()
    private var cPressed: Bool = false
    
    private let confirmButton = UIButton()
    
    var completion: ((Command) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    init() {
        super.init(frame: .zero)
        initView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView() {
        let stack = UIStackView(arrangedSubviews: [aButton, bButton, cButton, confirmButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        aButton.setTitle("A", for: .normal)
        bButton.setTitle("B", for: .normal)
        cButton.setTitle("C", for: .normal)
        confirmButton.setTitle("OK", for: .normal)
        
        aPressed = userDefault.bool(forKey: "abutton")
        bPressed = userDefault.bool(forKey: "bbutton")
        cPressed = userDefault.bool(forKey: "cbutton")
        
        if aPressed {
            aButton.setImage(image, for: .normal)
        } else {
            aButton.setImage(nil, for: .normal)
        }
        
        if bPressed {
            bButton.setImage(image, for: .normal)
        } else {
            bButton.setImage(nil, for: .normal)
        }
        
        if cPressed {
            cButton.setImage(image, for: .normal)
        } else {
            cButton.setImage(nil, for: .normal)
        }
    }
    
    private func setupActions() {
        aButton.addTarget(self, action: #selector(aButtonWasPressed), for: .touchUpInside)
        bButton.addTarget(self, action: #selector(bButtonWasPressed), for: .touchUpInside)
        cButton.addTarget(self, action: #selector(cButtonWasPressed), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonWasPressed), for: .touchUpInside)
    }
    
    @objc private func aButtonWasPressed() {
        aPressed.toggle()
        userDefault.set(aPressed, forKey: "abutton")
        
        if aPressed {
            aButton.setImage(image, for: .normal)
        } else {
            aButton.setImage(nil, for: .normal)
        }
    }
    
    @objc private func bButtonWasPressed() {
        bPressed.toggle()
        userDefault.set(bPressed, forKey: "bbutton")
        
        if bPressed {
            bButton.setImage(image, for: .normal)
        } else {
            bButton.setImage(nil, for: .normal)
        }
    }
    
    @objc private func cButtonWasPressed() {
        cPressed.toggle()
        userDefault.set(cPressed, forKey: "cbutton")
        
        if cPressed {
            cButton.setImage(image, for: .normal)
        } else {
            cButton.setImage(nil, for: .normal)
        }
    }
    
    @objc private func confirmButtonWasPressed() {
       completion?(createResult(areaA: aPressed, areaB: bPressed, areaC: cPressed))
    }
    
    private func createResult(areaA: Bool, areaB: Bool, areaC: Bool) -> Command {
        
        if areaA && areaB && areaC {
            return .arm
        }
        
        if areaA == false && areaB == false && areaC == false {
            return .disarm
        }
        
        if areaA && areaB == false && areaC == false {
            return .home_1
        }
        
        if areaA == false && areaB && areaC == false {
            return .home_2
        }
        
        if areaA == false && areaB == false && areaC {
            return .home_3
        }
        
        if areaA && areaB && areaC == false {
            return .home_1_2
        }
        
        if areaA && areaB == false && areaC {
            return .home_1_3
        }
        
        if areaA == false && areaB && areaC {
            return .home_2_3
        }
        
        return .disarm
    }
}
