//
//  NearByTableViewCell.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/10/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class NearByTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopSubTextLabel: UILabel!
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopLocationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var bookWahBtnOut: UIButton!
    @IBOutlet weak var internelViewOut: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        internelViewOut.layer.cornerRadius      =   10
        internelViewOut.layer.shadowRadius      =   4
        internelViewOut.layer.masksToBounds     =   false
        internelViewOut.layer.shadowColor       =   UIColor.darkGray.cgColor
        internelViewOut.layer.shadowOffset      =   CGSize(width: 0.0, height: 0.0)
        internelViewOut.layer.shadowOpacity     =   0.7
        bookWahBtnOut.layer.cornerRadius        =   5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
