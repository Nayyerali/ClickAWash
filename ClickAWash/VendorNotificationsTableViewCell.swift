//
//  VendorNotificationsTableViewCell.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class VendorNotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workerName: UILabel!
    @IBOutlet weak var notificationText: UILabel!
    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var notificationTIme: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        senderImage.roundedImage()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
