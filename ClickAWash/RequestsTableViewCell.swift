//
//  RequestsTableViewCell.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class RequestsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var internelViewOut: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var packagePrice: UILabel!
    @IBOutlet weak var vendorId: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var packageName: UILabel!
    @IBOutlet weak var acceptBtnOut: UIButton!
    @IBOutlet weak var rejectBtnOut: UIButton!
    @IBOutlet weak var internelStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.roundedImage()
        internelStackView.layer.cornerRadius    =   10
        packagePrice.layer.cornerRadius         =   10
        internelViewOut.layer.cornerRadius      =   10
        internelViewOut.layer.shadowRadius      =   4
        internelViewOut.layer.masksToBounds     =   false
        internelViewOut.layer.shadowColor       =   UIColor.darkGray.cgColor
        internelViewOut.layer.shadowOffset      =   CGSize(width: 0.0, height: 0.0)
        internelViewOut.layer.shadowOpacity     =   0.7
        acceptBtnOut.layer.cornerRadius         =   5
        rejectBtnOut.layer.cornerRadius         =   5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func rejectBtnPressed(_ sender: Any) {
        
    }
}
