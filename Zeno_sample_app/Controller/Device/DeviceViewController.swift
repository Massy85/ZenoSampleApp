//
//  DeviceViewController.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 18/03/22.
//

import UIKit

class DeviceViewController: BaseViewController {

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
        super.addLoadingView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        viewModel.completionOnPresentLoginViewController = {
            super.presentLogin {
                
                self.viewModel.completionOnUpdateUI = { device in
                    DispatchQueue.main.async {
                        self.container.removeAll()
                        self.container = device
                        self.tableView.reloadData()
                        super.removeLoadingView()
                    }
                }
                
                self.viewModel.getDeviceInfo()
            }
        }
        
        viewModel.completionOnUpdateUI = { device in
            DispatchQueue.main.async {
                self.container.removeAll()
                self.container = device
                self.tableView.reloadData()
                super.removeLoadingView()
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
