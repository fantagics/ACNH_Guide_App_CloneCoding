//
//  ETURL.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/09/06.
//

import UIKit

extension URL{
    static func villagerInfo(_ id: Int) -> String{
        return "https://acnhapi.com/v1/villagers/\(id)"
    }
    static func villagerProfile(_ id: Int) -> String{
        return "https://acnhapi.com/v1/images/villagers/\(id)"
    }
    static func villagerIcon(_ id: Int) -> String{
        return "https://acnhapi.com/v1/icons/villagers/\(id)"
    }
}
