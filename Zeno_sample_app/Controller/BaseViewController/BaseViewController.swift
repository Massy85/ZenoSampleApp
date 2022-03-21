//
//  BaseViewController.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 21/03/22.
//

import UIKit

class BaseViewController: UIViewController {
    let loadingView = LoadingView()
    
    func presentLogin(completion: @escaping () -> Void) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        
        controller.completion = { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    controller.dismiss(animated: true)
                    completion()
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Login failed", message: error.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel)
                alert.addAction(action)
                DispatchQueue.main.async {
                    controller.present(alert, animated: true)
                }
            }
        }
        
        self.present(controller, animated: true)
    }
    
    
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
