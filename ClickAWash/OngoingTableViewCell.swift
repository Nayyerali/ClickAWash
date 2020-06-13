//
//  OngoingTableViewCell.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class OngoingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var internelViewOut: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var packagePrice: UILabel!
    @IBOutlet weak var vendorId: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var packageName: UILabel!
    @IBOutlet weak var startServiceBtnOut: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.roundedImage()
        internelViewOut.layer.cornerRadius      =   10
        internelViewOut.layer.shadowRadius      =   4
        internelViewOut.layer.masksToBounds     =   false
        internelViewOut.layer.shadowColor       =   UIColor.darkGray.cgColor
        internelViewOut.layer.shadowOffset      =   CGSize(width: 0.0, height: 0.0)
        internelViewOut.layer.shadowOpacity     =   0.7
        startServiceBtnOut.layer.cornerRadius   =   5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func startServiceBtnPressed(_ sender: Any) {
        
    }
}
