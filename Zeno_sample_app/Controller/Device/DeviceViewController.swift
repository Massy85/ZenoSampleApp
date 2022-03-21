//
//  DeviceViewController.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 18/03/22.
//

import UIKit

class DeviceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = DeviceViewModel()
    var container = [PanelDeviceDataMO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "DeviceCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DeviceCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        viewModel.completionOnPresentLoginViewController = {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
            
            controller.completion = { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        controller.dismiss(animated: true)
                        
                        self.viewModel.completionOnUpdateUI = { device in
                            DispatchQueue.main.async {
                                self.container.removeAll()
                                self.container = device
                                self.tableView.reloadData()
                            }
                        }
                        self.viewModel.getDeviceInfo()
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
        
        viewModel.completionOnUpdateUI = { device in
            DispatchQueue.main.async {
                self.container.removeAll()
                self.container = device
                self.tableView.reloadData()
            }
        }
        
        viewModel.checkForLogin()
        viewModel.getDeviceInfo()
    }
}

extension DeviceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return container.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as? DeviceCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(container[indexPath.row])
        
        return cell
    }
}
