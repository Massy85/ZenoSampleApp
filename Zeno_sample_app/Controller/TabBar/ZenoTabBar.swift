//
//  NavigationController.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 14/03/22.
//

import UIKit

class ZenoTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupTab()
    }
    
    private func setupTab() {
        viewControllers = [
            createNavController(for: instantiateDashboardViewController(), title: "Dashboard", image: UIImage(systemName: "house")!),
            createNavController(for: instantiateNotificationViewController(), title: "Notification", image: UIImage(systemName: "message")!),
            createNavController(for: instantiateDeviceViewController(), title: "Devices", image: UIImage(systemName: "macmini")!)
        ]
    }
    
    private func instantiateDashboardViewController() -> DashboardViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
    }
    
    private func instantiateNotificationViewController() -> NotificationViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
    }
    
    private func instantiateDeviceViewController() -> DeviceViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "DeviceViewController") as! DeviceViewController
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}


class LoadingView: UIView {
    
    let activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    deinit {
        activityIndicator.stopAnimating()
    }
    
    private func setup() {
        backgroundColor = .white
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        activityIndicator.style = .large
        activityIndicator.color = .orange
        activityIndicator.startAnimating()
    }
    
    func remove() {
        activityIndicator.stopAnimating()
        self.removeFromSuperview()
    }
}
