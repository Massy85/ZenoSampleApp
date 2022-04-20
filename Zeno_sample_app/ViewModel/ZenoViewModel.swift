//
//  ZenoViewModel.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 18/03/22.
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

enum ButtonType {
    case arm
    case disarm
    case partial
}

class ZenoViewModel {
    let client = ZenoClient.shared
    var completionOnPresentLoginViewController: (() -> Void)?
    var completionOnState: (([ZenoCellObject], String, ZenoState) -> Void)?
    var completionOnevents: (([EventDataMO]) -> Void)?
    var completionOnDevice: (([PanelDeviceDataMO]) -> Void)?
    
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
                let mode = panelModeMO.mode
                guard mode != .unowned else { return }
                
                var container = [ZenoCellObject]()
                var text: String = ""
                
                switch mode {
                case .arm:
                    text = self.createCellForArmState().text
                    container = self.createCellForArmState().cellObjects
                case .disarm:
                    text = self.createCellForDisarmState().text
                    container = self.createCellForDisarmState().cellObjects
                case .home_1:
                    text = self.createCellForHome1State().text
                    container = self.createCellForHome1State().cellObjects
                case .home_2:
                    text = self.createCellForHome2State().text
                    container = self.createCellForHome2State().cellObjects
                case .home_3:
                    text = self.createCellForHome3State().text
                    container = self.createCellForHome3State().cellObjects
                default: break
                }
                
                self.completionOnState?(container, text, mode)
            case .failure:
                DispatchQueue.main.async {
                    self.completionOnPresentLoginViewController?()
                }
               
            }
        }
        
        client.performPollingFor(.state)
    }
    
    func totalArm() {
        client.completionOnSetPanelMode = { _ in
            self.client.resumePolling()
        }

        client.setPanelModeAt(.arm)
    }
    
    func disarm() {
        client.completionOnSetPanelMode = { _ in
            self.client.resumePolling()
        }
        
        client.setPanelModeAt(.disarm)
    }

    func partialArm(_ state: ZenoState) {
        client.completionOnSetPanelMode = { _ in
            self.client.resumePolling()
        }
        
        client.setPanelModeAt(state)
    }
    
    func getEvents() {
        client.completionOnEvents = { result in
            switch result {
            case .success(let events):
                self.client.resumePolling()
                guard let data = events.data else { return }
                self.completionOnevents?(data)
            case .failure:
                DispatchQueue.main.async {
                    self.completionOnPresentLoginViewController?()
                }
            }
        }
        
        client.performPollingFor(.events)
    }
    
    func getDeviceInfo() {
        client.completionOnPanelDevice = { result in
            switch result {
            case .success(let panelDeviceMO):
                guard let data = panelDeviceMO.data else { return }
                self.completionOnDevice?(data)
            case .failure:
                DispatchQueue.main.async {
                    self.completionOnPresentLoginViewController?()
                }
            }
        }
        
        client.performPollingFor(.device)
    }
}

extension ZenoViewModel {
    private func createCellForArmState() -> (text: String, cellObjects: [ZenoCellObject]) {
        let text = "La case è protetta"
        var container = [ZenoCellObject]()
        
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
        return (text, container)
    }
    
    private func createCellForDisarmState() -> (text: String, cellObjects: [ZenoCellObject]) {
        let text = "La case non è protetta"
        var container = [ZenoCellObject]()
        
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
        return (text, container)
    }
    
    private func createCellForHome1State() -> (text: String, cellObjects: [ZenoCellObject]) {
        let text = "PARZIALIZZAZIONE A"
        var container = [ZenoCellObject]()
        
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
        return (text, container)
    }
    
    private func createCellForHome2State() -> (text: String, cellObjects: [ZenoCellObject]) {
        let text = "PARZIALIZZAZIONE B"
        var container = [ZenoCellObject]()
        
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
        return (text, container)
    }
    
    private func createCellForHome3State() -> (text: String, cellObjects: [ZenoCellObject]) {
        let text = "PARZIALIZZAZIONE C"
        var container = [ZenoCellObject]()
        
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
        return (text, container)
    }
}
