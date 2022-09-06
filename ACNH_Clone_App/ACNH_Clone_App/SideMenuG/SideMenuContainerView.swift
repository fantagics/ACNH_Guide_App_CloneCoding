//
//  SideMenuContainerView.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/07/25.
//

import UIKit

class SideMenuContainerView: UIViewController {
    var isOpen = [false, false, false, false]
    let menuList: [String] = ["이웃주민", "도감", "컬렉션", "가이드"]
    let menuDesc: [[String]] = [
        ["주민목록", "우리 섬 주민", "내 선호 주민", "주민 상성표"],
        ["곤충", "물고기", "해산물", "화석", "미술품", "실시간 포획 가능"],
        ["아이템 컬렉션", "특별한 아이템", "DIY레시피", "제스처"],
        ["잠금 해제 조건", "특별한 주민들", "너굴 마일리지", "꽃 교배하기", "마일리지 섬", "무 주식 계산기", "우리 섬 달력"]
    ]
    
    //MARK: - @IBOutlet
    @IBOutlet weak var sideMenuTV: UITableView!
    
    
    //MARK: - LC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sideHeader = Bundle.main.loadNibNamed("TableHeader", owner: self, options: nil)?.last as? UIView
        let sideFooter = Bundle.main.loadNibNamed("TableFooter", owner: self, options: nil)?.last as? UIView
        sideMenuTV.tableHeaderView = sideHeader
        sideMenuTV.tableFooterView = sideFooter
        sideMenuTV.tableHeaderView?.frame.size.height = CGFloat(80)
        
        sideMenuTV.register(UINib(nibName: "SectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "customHeader")
        sideMenuTV.register(UINib(nibName: "DetailTVCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
    }
    
}

extension SideMenuContainerView: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuList.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customHeader") as? SectionHeader else{return UITableViewHeaderFooterView()}
        
        headerView.isOpened = isOpen[section]
        headerView.sectionIndex = section
        headerView.titleLabel.text = menuList[section]
        headerView.delegate = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOpen[section] == true {
            return menuDesc[section].count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DetailTVCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? DetailTVCell else{return UITableViewCell()}
        
        cell.descLabel.text = menuDesc[indexPath.section][indexPath.row]
        
        return cell
        
    }
}

extension SideMenuContainerView: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("이웃주민")
            switch indexPath.row{
            case 0:
                print("주민목록")
//                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VillagersSB")
//                self.navigationController?.pushViewController(nextVC!, animated: true)
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VillagersListMultiSB") as? VillagersListMultiVC else{return}
                nextVC.numberOfVillagerVC = 0
                nextVC.titleText = "주민목록"
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 1:
                print("우리섬주민")
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VillagersListMultiSB") as? VillagersListMultiVC else{return}
                nextVC.numberOfVillagerVC = 1
                nextVC.titleText = "우리 섬 주민"
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 2:
                print("내선호주민")
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VillagersListMultiSB") as? VillagersListMultiVC else{return}
                nextVC.numberOfVillagerVC = 2
                nextVC.titleText = "내 선호 주민"
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 3:
                print("주민상성표")
            default:
                print("Not Exist More Row from Section Zero")
            }
        case 1:
            print("도감")
        case 2:
            print("컬렉션")
        case 3:
            print("가이드")
        default:
            print("Not Exist More Section")
        }
    }
}


extension SideMenuContainerView: SideBarSectionHeaderDelegate{
    func didTouchSection(_ sectionIndex: Int) {
        isOpen[sectionIndex].toggle()
        sideMenuTV.reloadData()
    }
}
