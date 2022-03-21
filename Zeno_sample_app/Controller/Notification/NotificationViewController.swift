//
//  NotificationViewController.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 14/03/22.
//

import UIKit

class NotificationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = NotificationViewModel()
    var container = [EventDataMO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "EventsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EventsCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.addLoadingView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        viewModel.completionOnPresentLoginViewController = {
            super.presentLogin {
                self.viewModel.completionOnUpdateUI = { events in
                    DispatchQueue.main.async {
                        self.container.removeAll()
                        self.container = events
                        self.tableView.reloadData()
                        super.removeLoadingView()
                    }
                }
                
                self.viewModel.getEvents()
            }
        }
        
        viewModel.completionOnUpdateUI = { events in
            DispatchQueue.main.async {
                self.container.removeAll()
                self.container = events
                self.tableView.reloadData()
                super.removeLoadingView()
            }
        }
        
        viewModel.checkForLogin()
        viewModel.getEvents()
    }

}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return container.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as? EventsCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(container[indexPath.row])
        return cell
    }
}
