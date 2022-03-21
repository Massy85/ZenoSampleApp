//
//  ZenoClient.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 17/03/22.
//

import Foundation

public class ZenoClient {
    // MARK: - Properties

    public static let shared = ZenoClient()
    
    public typealias LoginResult = Result<LoginMO,Error>
    public typealias GETPanelModeResult = Result<PanelModeMO,Error>
    public typealias SETPanelModeResult = Result<PanelModePostMO,Error>
    public typealias GETPanelDeviceResult = Result<PanelDeviceMO,Error>
    public typealias GETEventsResult = Result<EventMO,Error>
        
    private let client = Client()
    private var token: String? = nil
    public var loginIsNeeded: Bool = true
    private var timer: Timer?
    
    // MARK: - Lifecycle

    private init() {}
    
    public var completionOnLogin: ((LoginResult) -> Void)?
    
    public func login(_ username: String, _ password: String) {
        var loader: LoginLoaderAdapter? = LoginLoaderAdapter(username: username, password: password, client: client)
        loader?.load { result in
            if case let .success(loginMO) = result {
                self.token = loginMO.token
                self.loginIsNeeded = false
            } else {
                self.loginIsNeeded = true
            }
            self.completionOnLogin?(result)
            loader = nil
        }
    }
    
    func startPolling() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(performPolling), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc private func performPolling() {
        getPanelMode()
    }
    
    public var completionOnGetPanelMode: ((GETPanelModeResult) -> Void)?
    
    private func getPanelMode() {
        guard let token = token else { return }
        print("---> [Zeno][Polling][Starting]")
        var loader: GetPanelModeLoaderAdapter? = GetPanelModeLoaderAdapter(token, client: client)
        
        loader?.load { result in
            if case let .success(panelModeMO) = result {
                self.token = panelModeMO.token
            }
            self.completionOnGetPanelMode?(result)
            loader = nil
        }
    }
    
    public var completionOnSetPanelMode: ((SETPanelModeResult) -> Void)?
    
    public func setPanelModeAt(_ mode: MasterMode) {
        guard let token = token else { return }
        
        timer?.invalidate()
        timer = nil
        
        print("---> [Zeno][Polling][Stopped]")
        print("---> [Zeno][SetPanelMode][\(mode.rawValue)]")
        
        var loader: SetPanelModeLoaderAdapter? = SetPanelModeLoaderAdapter(token: token, mode: mode, client: client)
        
        loader?.load { result in
            if case let .success(panelModePostMO) = result {
                self.token = panelModePostMO.token
            }
            
            self.completionOnSetPanelMode?(result)
            loader = nil
        }
    }
    
    public var completionOnPanelDevice: ((GETPanelDeviceResult) -> Void)?
    
    public func getPanelDevice() {
        guard let token = token else { return }
        
        timer?.invalidate()
        timer = nil
        
        print("---> [Zeno][Polling][Stopped]")
        print("---> [Zeno][GetPanelDevice]")
        
        var loader: GetPanelDeviceLoaderAdapter? = GetPanelDeviceLoaderAdapter(token, client)
        
        loader?.load { result in
            if case let .success(panelDeviceMO) = result {
                self.token = panelDeviceMO.token
            }
            
            self.completionOnPanelDevice?(result)
            loader = nil
        }
    }
    
    public var completionOnEvents: ((GETEventsResult) -> Void)?
    
    public func getEvents() {
        guard let token = token else { return }
        
        timer?.invalidate()
        timer = nil
        
        print("---> [Zeno][Polling][Stopped]")
        print("---> [Zeno][GetEvents]")
        
        var loader: GetEventsLoaderAdapter? = GetEventsLoaderAdapter(token: token, client: client)
        
        loader?.load { result in
            if case let .success(eventMO) = result {
                self.token = eventMO.token
            }
            
            self.completionOnEvents?(result)
            loader = nil
        }
    }
    
    public func resumePolling() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.startPolling()
        }
    }
}
