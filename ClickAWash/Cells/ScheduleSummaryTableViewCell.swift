//
//  ScheduleSummaryTableViewCell.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/25/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class ScheduleSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var packageDescriptionLabel: UILabel!
    @IBOutlet weak var packageDetailsLabel: UILabel!
    @IBOutlet weak var dateAndTImeLabel: UILabel!
    @IBOutlet weak var packageAmountLabel: UILabel!
    @IBOutlet weak var couponAmountLabel: UILabel!
    @IBOutlet weak var walletAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
