//
//  BaseViewController.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 21/03/22.
//

import UIKit

class BaseViewController: UIViewController {
    let loadingView = LoadingView()
    
    
    func addLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func removeLoadingView() {
        loadingView.remove()
    }
}
