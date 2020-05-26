//
//  CompletedWashBookings.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/26/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class CompletedWashBookings: UITableViewCell {

    @IBOutlet weak var completedPackageName: UILabel!
    @IBOutlet weak var bookingStatus: UILabel!
    @IBOutlet weak var completedPackageDescription: UILabel!
    @IBOutlet weak var completedPackagePrice: UILabel!
    @IBOutlet weak var completedPackageDetails: UILabel!
    @IBOutlet weak var completedBookingId: UILabel!
    @IBOutlet weak var completedPackageDateAndTime: UILabel!
    @IBOutlet weak var payNowBtnOut: UIButton!
    @IBOutlet weak var internelViewOut: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        internelViewOut.layer.cornerRadius = 10
        internelViewOut.layer.shadowRadius = 4
        internelViewOut.layer.masksToBounds = false
        internelViewOut.layer.shadowColor = UIColor.gray.cgColor
        internelViewOut.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        internelViewOut.layer.shadowOpacity = 0.7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func PayNowBtnPressed(_ sender: Any) {
        
    }
}
