//
//  DeviceCell.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 18/03/22.
//

import UIKit

class DeviceCell: UITableViewCell {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typeNoLabel: UILabel!
    @IBOutlet weak var bypassLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var statusOpenLabel: UILabel!
    @IBOutlet weak var statusFaultLabel: UILabel!
    @IBOutlet weak var deviceCategoryLabel: UILabel!
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        addressLabel.text = ""
        groupLabel.text = ""
        statusLabel.text = ""
        idLabel.text = ""
        typeNoLabel.text = ""
        bypassLabel.text = ""
        rssiLabel.text = ""
        statusOpenLabel.text = ""
        statusFaultLabel.text = ""
        deviceCategoryLabel.text = ""
        attributeLabel.text = ""
        typeLabel.text = ""
        areaLabel.text = ""
    }

    
    func configureCell(_ device: PanelDeviceDataMO) {
        addressLabel.text = "Address: \(device.address ?? "No data")"
        groupLabel.text = "Group: \(device.group ?? "No data")"
        statusLabel.text = "Status: \(device.status ?? "No data")"
        idLabel.text = "Id: \(device.id ?? "No data")"
        typeNoLabel.text = "Type-no: \(device.typeNo ?? "No data")"
        bypassLabel.text = "Bypass: \(device.bypass ?? "No data")"
        rssiLabel.text = "Rssi: \(device.rssi ?? "No data")"
        deviceCategoryLabel.text = "Category: \(device.deviceCategory ?? "No data")"
        attributeLabel.text = "Attribute: \(device.attr ?? "No data")"
        typeLabel.text = "Type: \(device.type ?? "No data")"
        areaLabel.text = "Area: \(device.area ?? "No data")"
        
        let statusOpen = device.statusOpen?.joined(separator: "-")
        statusLabel.text = "Status open: \(statusOpen ?? "No data")"
        
        let statusFault = device.statusFault?.joined(separator: "-")
        statusFaultLabel.text = "Status fault: \(statusFault ?? "No data")"
    }
    
}
