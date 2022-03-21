//
//  LoginViewController.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 19/01/22.
//

import UIKit

protocol LoginControllerProtocol: AnyObject {
    func success()
}

class LoginViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    // MARK: - Properties

    let client = ZenoClient.shared
    weak var delegate: LoginControllerProtocol?
    var completion: ((ZenoClient.LoginResult) -> Void)?
 
    // MARK: - Actions

    @IBAction func loginButtonWasPressed(_ sender: UIButton) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        
        client.completionOnLogin = {
            self.completion?($0)
        }
        
        client.login(username, password)
    }
}
