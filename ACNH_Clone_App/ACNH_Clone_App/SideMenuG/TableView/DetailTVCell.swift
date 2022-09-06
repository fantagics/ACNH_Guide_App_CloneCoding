//
//  DetailTVCell.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/07/26.
//

import UIKit

class DetailTVCell: UITableViewCell {
    
    @IBOutlet weak var descImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
