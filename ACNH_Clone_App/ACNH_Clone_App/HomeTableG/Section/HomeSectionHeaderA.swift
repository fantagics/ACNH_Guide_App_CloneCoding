//
//  HomeSectionHeaderA.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/07/29.
//

import UIKit

class HomeSectionHeaderA: UITableViewHeaderFooterView {
    var isOpened = false
    var sectionIndex = 0
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    var delegate: HomeSectionHeaderDelegate?
    
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var isVisable: UIImageView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if isOpened{
            isVisable.image = UIImage(systemName: "chevron.up")
        }
        else{
            isVisable.image = UIImage(systemName: "chevron.down")
        }
        
        self.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(selectedHomeSection))
    }
    
    @objc func selectedHomeSection(_ sender: UITapGestureRecognizer){
        delegate?.didTapSection(self.sectionIndex)
    }
}

protocol HomeSectionHeaderDelegate: AnyObject{
    func didTapSection(_ sectionIndex: Int)
}
