//
//  ETTextField.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/09/02.
//

import UIKit

extension UITextField{
    func addLeftPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
