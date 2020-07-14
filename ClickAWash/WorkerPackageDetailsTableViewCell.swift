//
//  WorkerPackageDetailsTableViewCell.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 11/07/2020.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class WorkerPackageDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var internelViewOutForWorkerDetails: UIView!
    @IBOutlet weak var packageNameForWorkerDetails: UILabel!
    @IBOutlet weak var packageDescriptionForWorkerDetails: UILabel!
    @IBOutlet weak var packagePriceForWorkerDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        internelViewOutForWorkerDetails.layer.cornerRadius      =   10
        internelViewOutForWorkerDetails.layer.shadowRadius      =   4
        internelViewOutForWorkerDetails.layer.masksToBounds     =   false
        internelViewOutForWorkerDetails.layer.shadowColor       =   UIColor.darkGray.cgColor
        internelViewOutForWorkerDetails.layer.shadowOffset      =   CGSize(width: 0.0, height: 0.0)
        internelViewOutForWorkerDetails.layer.shadowOpacity     =   0.7
        packagePriceForWorkerDetails.layer.cornerRadius         =   20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
