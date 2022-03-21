//
//  DashboardViewController.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 14/03/22.
//

import UIKit

class DashboardViewController: BaseViewController {

    @IBOutlet weak var panelStateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusView: UIView!
    
    let viewModel = DashboardViewModel()
    var container = [ZenoCellObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ZenoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ZenoCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        super.addLoadingView()
        
        tableView.isScrollEnabled = false
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
                        
                        self.viewModel.completionOnUpdateUI = { objects, text, state in
                            DispatchQueue.main.async {
                                
                                switch state {
                                case .unowned:
                                    self.statusView.backgroundColor = UIColor(named: "alarm")
                                case .arm:
                                    self.statusView.backgroundColor = UIColor(named: "arm")
                                case .disarm:
                                    self.statusView.backgroundColor = UIColor(named: "disarm")
                                case .home_1, .home_2, .home_3:
                                    self.statusView.backgroundColor = UIColor(named: "partial")
                                }
                                
                                self.container.removeAll()
                                self.panelStateLabel.text = text
                                self.container = objects
                                self.tableView.reloadData()
                                super.removeLoadingView()
                            }
                        }
                        self.viewModel.getPanelMode()
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
        
        viewModel.completionOnUpdateUI = { objects, text, state in
            DispatchQueue.main.async {
                
                switch state {
                case .unowned:
                    self.statusView.backgroundColor = UIColor(named: "alarm")
                case .arm:
                    self.statusView.backgroundColor = UIColor(named: "arm")
                case .disarm:
                    self.statusView.backgroundColor = UIColor(named: "disarm")
                case .home_1, .home_2, .home_3:
                    self.statusView.backgroundColor = UIColor(named: "partial")
                }
                
                self.container.removeAll()
                self.panelStateLabel.text = text
                self.container = objects
                self.tableView.reloadData()
                super.removeLoadingView()
            }
        }
        
        viewModel.checkForLogin()
        viewModel.getPanelMode()
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return container.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ZenoCell", for: indexPath) as? ZenoCell else { return UITableViewCell() }
        
        cell.completionOnButtonPressed = { partial in
            switch partial {
            case .arm:
                self.viewModel.totalArm()
            case .disarm:
                self.viewModel.disarm()
            case .home_1:
                self.viewModel.partialArm(.home_1)
            case .home_2:
                self.viewModel.partialArm(.home_2)
            case .home_3:
                self.viewModel.partialArm(.home_3)
            default: break
            }
        }
        
        cell.configureCell(container[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
}
