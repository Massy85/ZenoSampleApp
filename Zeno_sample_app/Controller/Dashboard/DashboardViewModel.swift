//
//  DashboardViewModel.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 14/03/22.
//

import Foundation

enum State {
    case unowned
    case selected(_ selected: Bool, _ partial: Partial, _ cellState: ButtonType)
}

enum Partial {
    case none
    case home_1
    case home_2
    case home_3
}
//

enum ButtonType {
    case arm
    case disarm
    case partial
}

enum StateArea {
    case unowned
    case arm
    case disarm
    case home_1
    case home_2
    case home_3
    case home_1_2
    case home_1_3
    case home_2_3
}

enum Command {
    case arm
    case disarm
    case home_1
    case home_2
    case home_3
    case home_1_2
    case home_1_3
    case home_2_3
    
    var command: [StateArea] {
        switch self {
        case .arm:
            return [.arm]
        case .disarm:
            return [.home_1]
        case .home_1:
            return [.home_1]
        case .home_2:
            return [.home_2]
        case .home_3:
            return [.home_3]
        case .home_1_2:
            return [.home_1, .home_2]
        case .home_1_3:
            return [.home_1, .home_3]
        case .home_2_3:
            return [.home_2, .home_3]
        }
    }
}
struct PartialState {
    var home_1: [StateArea] = [.home_1]
    var home_2: [StateArea] = [.home_2]
    var home_3: [StateArea] = [.home_3]
    var home_1_2: [StateArea] = [.home_1, .home_2]
    var home_1_3: [StateArea] = [.home_1, .home_3]
    var home_2_3: [StateArea] = [.home_2, .home_3]
}
//
protocol ViewModelProtocol: AnyObject {
    func presentLoginController()
    func updatePanelStateLabel(_ text: String)
    func updateButtons(_ state: State)
}

class DashboardViewModel {
    
    let client = ZenoClient.shared
    
    var completionOnPresentLoginViewController: (() -> Void)?
    var completionOnUpdateUI: (([ZenoCellObject], String, ZenoState) -> Void)?
    
    init() {}

    func checkForLogin() {
        if client.loginIsNeeded {
            completionOnPresentLoginViewController?()
            return
        }
    }
    
    func getPanelMode() {
        
        client.completionOnGetPanelMode = { result in
            switch result {
            case .success(let panelModeMO):
                
                guard let mode = panelModeMO.mode else { return }
                
                var container = [ZenoCellObject]()
                var text: String = ""
                
                switch mode {
                case .arm:
                    text = "La case è protetta"
                    let first = ZenoCellObject(
                        title: "Arma totale",
                        state: .arm,
                        expandable: false,
                        isHighlighted: true,
                        isEnabled: false,
                        buttonType: .arm
                    )
                    container.append(first)
                    let second = ZenoCellObject(
                        title: "Disarma",
                        state: .unowned,
                        expandable: false,
                        isHighlighted: false, isEnabled: true,
                        buttonType: .disarm
                    )
                    container.append(second)
                    let third = ZenoCellObject(
                        title: "Parzializza",
                        state: .unowned,
                        expandable: true,
                        isHighlighted: false,
                        isEnabled: false,
                        buttonType: .partial
                    )
                    container.append(third)
                case .disarm:
                    text = "La case non è protetta"
                    let first = ZenoCellObject(
                        title: "Arma totale",
                        state: .unowned,
                        expandable: false,
                        isHighlighted: false,
                        isEnabled: true,
                        buttonType: .arm
                    )
                    container.append(first)
                    let second = ZenoCellObject(
                        title: "Disarma",
                        state: .disarm,
                        expandable: false,
                        isHighlighted: true,
                        isEnabled: false,
                        buttonType: .disarm
                    )
                    container.append(second)
                    let third = ZenoCellObject(
                        title: "Parzializza",
                        state: .unowned,
                        expandable: true,
                        isHighlighted: false,
                        isEnabled: true,
                        buttonType: .partial
                    )
                    container.append(third)
                case .home_1:
                    text = "PARZIALIZZAZIONE A"
                    let first = ZenoCellObject(
                        title: "Arma totale",
                        state: .unowned,
                        expandable: false,
                        isHighlighted: false,
                        isEnabled: true,
                        buttonType: .arm
                    )
                    container.append(first)
                    let second = ZenoCellObject(
                        title: "Disarma",
                        state: .unowned,
                        expandable: false,
                        isHighlighted: false,
                        isEnabled: true,
                        buttonType: .disarm
                    )
                    container.append(second)
                    let third = ZenoCellObject(
                        title: "Parzializza",
                        state: .home_1,
                        expandable: true,
                        isHighlighted: true,
                        isEnabled: false,
                        buttonType: .partial
                    )
                    container.append(third)
                case .home_2:
                    text = "PARZIALIZZAZIONE B"
                    let first = ZenoCellObject(
                        title: "Arma totale",
                        state: .unowned,
                        expandable: false,
                        isHighlighted: false,
                        isEnabled: true,
                        buttonType: .arm
                    )
                    container.append(first)
                    let second = ZenoCellObject(
                        title: "Disarma",
                        state: .unowned,
                        expandable: false,
                        isHighlighted: false,
                        isEnabled: true,
                        buttonType: .disarm
                    )
                    container.append(second)
                    let third = ZenoCellObject(
                        title: "Parzializza",
                        state: .home_2,
                        expandable: true,
                        isHighlighted: true,
                        isEnabled: false,
                        buttonType: .partial
                    )
                    container.append(third)
                case .home_3:
                    text = "PARZIALIZZAZIONE C"
                    let first = ZenoCellObject(
                        title: "Arma totale",
                        state: .unowned,
                        expandable: false,
                        isHighlighted: false,
                        isEnabled: true,
                        buttonType: .arm
                    )
                    container.append(first)
                    let second = ZenoCellObject(
                        title: "Disarma",
                        state: .unowned,
                        expandable: false,
                        isHighlighted: false,
                        isEnabled: true,
                        buttonType: .disarm
                    )
                    container.append(second)
                    let third = ZenoCellObject(
                        title: "Parzializza",
                        state: .home_3,
                        expandable: true,
                        isHighlighted: true,
                        isEnabled: false,
                        buttonType: .partial
                    )
                    container.append(third)
                default: break
                }
                
                self.completionOnUpdateUI?(container, text, mode)
            case .failure:
                DispatchQueue.main.async {
                    self.completionOnPresentLoginViewController?()
                }
               
            }
        }
        
        client.startPolling()
    }
    
    func totalArm() {
        client.completionOnSetPanelMode = { result in
            switch result {
            case .success:
                self.client.resumePolling()
            case .failure(let error):
                fatalError()
            }
        }
        
        client.setPanelModeAt(.arm)
    }
    
    func disarm() {
        client.completionOnSetPanelMode = { result in
            switch result {
            case .success:
                self.client.resumePolling()
            case .failure(let error):
                fatalError()
            }
        }
        
        client.setPanelModeAt(.disarm)
    }

    func partialArm(_ state: Command) {
        let group = DispatchGroup()
        
        client.completionOnSetPanelMode = { result in
            switch result {
            case .success:
                self.client.resumePolling()
            case .failure(let error):
                fatalError()
            }
            group.leave()
        }
        
        let commands = state.command
        
        
        commands.forEach {
            switch $0 {
            case .arm:
                client.setPanelModeAt(.arm)
            case .disarm:
                client.setPanelModeAt(.home_1)
            case .home_1:
                client.setPanelModeAt(.home_1)
            case .home_2:
                client.setPanelModeAt(.home_2)
            case .home_3:
                client.setPanelModeAt(.home_3)
            default : break
            }
            group.enter()
        }
    }
}
