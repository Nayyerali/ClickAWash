//
//  DetailsTableViewCell.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var packagePrice: UILabel!
    @IBOutlet weak var vendorId: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var packageDescription: UILabel!
    @IBOutlet weak var serviceDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.roundedImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
