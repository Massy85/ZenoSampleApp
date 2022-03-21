//
//  DeviceViewModel.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 18/03/22.
//

import Foundation

class DeviceViewModel {
    
    let client = ZenoClient.shared
    var completionOnPresentLoginViewController: (() -> Void)?
    var completionOnUpdateUI: (([PanelDeviceDataMO]) -> Void)?
    
    init() {}
    
    func checkForLogin() {
        if client.loginIsNeeded {
            completionOnPresentLoginViewController?()
            return
        }
    }
    
    func getDeviceInfo() {
        client.completionOnPanelDevice = { result in
            switch result {
            case .success(let panelDeviceMO):
                guard let data = panelDeviceMO.data else { return }
                self.completionOnUpdateUI?(data)
            case .failure:
                DispatchQueue.main.async {
                    self.completionOnPresentLoginViewController?()
                }
            }
        }
        
        client.getPanelDevice()
    }
}
