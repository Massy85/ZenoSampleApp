//
//  ZenoCell.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 17/03/22.
//

import UIKit

class ZenoCell: UITableViewCell {
    
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var expandableView: UIView!
    @IBOutlet weak var expandableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var expandableViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var expandableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainButton: RoundButton!
    @IBOutlet weak var partialAButton: RoundButton!
    @IBOutlet weak var partialBButton: RoundButton!
    @IBOutlet weak var partialCButton: RoundButton!
    
    var expandable: Bool = false
    var completionOnButtonPressed: ((ZenoState) -> Void)?
    var state: ZenoState? = nil
    var commandToSend: ZenoState?
    var buttonType: ButtonType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        partialAButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        partialBButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        partialCButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainButton.isEnabled = true
        canvasView.backgroundColor = .clear
        expandable = false
        commandToSend = prepareCommandToSend()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        canvasView.layer.cornerRadius = canvasView.frame.height / 2
    }
    
    @objc private func buttonWasPressed(_ sender: RoundButton) {
        if sender.hash == mainButton.hash {
            
            guard let buttonType = buttonType else { return }

            switch buttonType {
            case .arm:
                completionOnButtonPressed?(.arm)
            case .disarm:
                completionOnButtonPressed?(.disarm)
            case .partial:
                guard let commandToSend = commandToSend else { return }

                completionOnButtonPressed?(commandToSend)
            }
            return 
        }
        
        if sender.hash == partialAButton.hash {
            commandToSend = .home_1
            savePartialButtonState(first: true, second: false, third: false)
            return
        }
        
        if sender.hash == partialBButton.hash {
            commandToSend = .home_2
            savePartialButtonState(first: false, second: true, third: false)
            return
        }
        
        if sender.hash == partialCButton.hash {
            commandToSend = .home_3
            savePartialButtonState(first: false, second: false, third: true)
            return
        }
        
    }
    
    private func savePartialButtonState(first: Bool, second: Bool, third: Bool) {
        partialAButton.backgroundColor = first ? .orange : .clear
        partialBButton.backgroundColor = second ? .orange : .clear
        partialCButton.backgroundColor = third ? .orange : .clear
        
        UserDefaults.standard.set(first, forKey: "aButton")
        UserDefaults.standard.set(second, forKey: "bButton")
        UserDefaults.standard.set(third, forKey: "cButton")
    }
    
    private func prepareCommandToSend() -> ZenoState {
        if UserDefaults.standard.bool(forKey: "aButton") {
            return .home_1
        }
        
        if UserDefaults.standard.bool(forKey: "bButton") {
            return .home_2
        }
        
        if UserDefaults.standard.bool(forKey: "cButton") {
            return .home_3
        }
        
        return .home_1
    }
    
    func configureCell(_ object: ZenoCellObject) {
        mainButton.setTitle(object.title, for: .normal)
        buttonType = object.buttonType
        expandable = object.expandable
        
        expandableView.isHidden = !expandable
        expandableViewHeight.constant = expandable ? 30 : 0
        expandableViewBottomConstraint.constant = expandable ? 10 : 0
        expandableViewTopContraint.constant = expandable ? 10 : 0
        
        mainButton.isEnabled = object.isEnabled
        canvasView.backgroundColor = object.isHighlighted ? .orange : .clear
        
        state = object.state
        
        if expandable {
            partialAButton.backgroundColor = UserDefaults.standard.bool(forKey: "aButton") ? .orange : .clear
            partialBButton.backgroundColor = UserDefaults.standard.bool(forKey: "bButton") ? .orange : .clear
            partialCButton.backgroundColor = UserDefaults.standard.bool(forKey: "cButton") ? .orange : .clear
        }
    }
    
}


public struct ZenoCellObject {
    let title: String
    let state: ZenoState
    let expandable: Bool
    let isHighlighted: Bool
    let isEnabled: Bool
    let buttonType: ButtonType
}
