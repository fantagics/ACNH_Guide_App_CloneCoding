//
//  TableFooter.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/07/25.
//

import UIKit

class TableFooter: UITableViewHeaderFooterView {
    
    @IBOutlet weak var rmAdBtn: UIButton!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        rmAdBtn.layer.cornerRadius = rmAdBtn.frame.height/2
    }
    
    
    @IBAction func connectEmail(_ sender: UIButton) {
    }
    @IBAction func connectDiscode(_ sender: UIButton) {
    }
    @IBAction func connectInstagram(_ sender: UIButton) {
    }
    @IBAction func removeAd(_ sender: UIButton) {
    }
    @IBAction func updateHistory(_ sender: UIButton) {
    }
    
}
