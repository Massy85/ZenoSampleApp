//
//  EventsCell.swift
//  Zeno_sample_app
//
//  Created by Massimiliano Bonafede on 18/03/22.
//

import UIKit

class EventsCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        subTitleLabel.text = ""
        dateLabel.text = ""
    }
    
    func configureCell(_ event: EventDataMO) {
        titleLabel.text = event.cidTrans
        subTitleLabel.text = event.userTrans
        dateLabel.text = event.time
    }
    
}
