//
//  NotificationViewModel.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 18/03/22.
//

import Foundation

class NotificationViewModel {
    
    let client = ZenoClient.shared
    var completionOnPresentLoginViewController: (() -> Void)?
    var completionOnUpdateUI: (([EventDataMO]) -> Void)?
    
    init() {}
    
    func checkForLogin() {
        if client.loginIsNeeded {
            completionOnPresentLoginViewController?()
            return
        } 
    }
    
    func getEvents() {
        client.completionOnEvents = { result in
            switch result {
            case .success(let events):
                self.client.resumePolling()
                guard let data = events.data else { return }
                self.completionOnUpdateUI?(data)
            case .failure:
                DispatchQueue.main.async {
                    self.completionOnPresentLoginViewController?()
                }
            }
        }
        
        client.getEvents()
    }
}
