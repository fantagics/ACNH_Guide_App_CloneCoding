//
//  ETAlertController.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/09/06.
//

import UIKit

extension UIAlertController{
    static func overVillagers() -> UIAlertController {
        let alertController = UIAlertController(title: "등록실패", message: "더이상 주민을 추가할 수 없습니다.(최대10명)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        return alertController
    }
}
