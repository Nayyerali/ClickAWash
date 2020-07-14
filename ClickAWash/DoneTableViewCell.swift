//
//  DoneTableViewCell.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class DoneTableViewCell: UITableViewCell {
    
    @IBOutlet weak var internelViewOut: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var packagePrice: UILabel!
    @IBOutlet weak var vendorId: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var packageName: UILabel!
    @IBOutlet weak var backgroundBlueView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.roundedImage()
        internelViewOut.layer.cornerRadius         =   10
        internelViewOut.layer.shadowRadius         =   4
        internelViewOut.layer.masksToBounds        =   false
        internelViewOut.layer.shadowColor          =   UIColor.darkGray.cgColor
        internelViewOut.layer.shadowOffset         =   CGSize(width: 0.0, height: 0.0)
        internelViewOut.layer.shadowOpacity        =   0.7
        backgroundBlueView.layer.cornerRadius      =   10
        backgroundBlueView.layer.shadowRadius      =   4
        backgroundBlueView.layer.masksToBounds     =   false
        backgroundBlueView.layer.shadowColor       =   UIColor.darkGray.cgColor
        backgroundBlueView.layer.shadowOffset      =   CGSize(width: 0.0, height: 0.0)
        backgroundBlueView.layer.shadowOpacity     =   0.7
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        internelViewOut.roundCorners(corners: [.topLeft], radius: 60)
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
