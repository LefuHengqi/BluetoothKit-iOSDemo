//
//  CoconutCollectionViewCell.swift
//  PPBluetoothKitDemo
//
//  Created by 杨青山 on 2023/8/9.
//

import UIKit

class CoconutCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        
        mainView.layer.borderWidth = 1
        
        mainView.layer.cornerRadius = 12
        
        mainView.layer.masksToBounds = true
    }
    
}
