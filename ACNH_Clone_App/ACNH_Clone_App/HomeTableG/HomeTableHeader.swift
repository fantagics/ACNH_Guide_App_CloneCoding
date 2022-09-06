//
//  HomeTableHeader.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/07/28.
//

import UIKit

class HomeTableHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var blueBackView: UIView!
    @IBOutlet weak var whiteBackView: UIView!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nickname: UIButton!
    @IBOutlet weak var islandName: UIButton!
    @IBOutlet weak var friendCode: UILabel!
    @IBOutlet weak var dreamCode: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        blueBackView.layer.cornerRadius = 20
        blueBackView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        whiteBackView.layer.cornerRadius = 10
        whiteBackView.layer.borderWidth = 0.3
        whiteBackView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        profileView.layer.cornerRadius = 15
        
        nickname.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        islandName.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        loadUser()
    }
    
    @objc func didTapButton(_ sender: UIButton){
        NotificationCenter.default.post(name: Notification.Name("tableHeaderRequest"), object: nil)
    }
    
    func loadUser(){
        if !sharedData.st.userName.isEmpty {
            nickname.setTitle(sharedData.st.userName, for: .normal)
        }else{ nickname.setTitle("", for: .normal) }
        if !sharedData.st.userIslandName.isEmpty {
            islandName.setTitle(sharedData.st.userIslandName, for: .normal)
        }
        if !sharedData.st.userFriendsCode.isEmpty {
            friendCode.text = sharedData.st.userFriendsCode
        }else{ friendCode.text = "" }
        if !sharedData.st.userDreamCode.isEmpty {
            dreamCode.text = sharedData.st.userDreamCode
        }else{ dreamCode.text = "" }
        
        if sharedData.st.userName.isEmpty && sharedData.st.userIslandName.isEmpty && sharedData.st.userFriendsCode.isEmpty && sharedData.st.userDreamCode.isEmpty && sharedData.st.userFruit.isEmpty && sharedData.st.userArea.isEmpty{
            friendCode.text = "friend code"
            dreamCode.text = "dream code"
            nickname.setTitle("섬 정보를 입력해주세요", for: .normal)
            islandName.setTitle("", for: .normal)
        }
    }
}
