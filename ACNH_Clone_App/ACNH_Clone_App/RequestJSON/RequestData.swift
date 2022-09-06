//
//  RequestData.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/08/06.
//

import Foundation
import UIKit

func requestVillager(_ villagerID: Int){
    guard let url: URL = URL(string: URL.villagerInfo(villagerID))else{return}
    let session: URLSession = URLSession(configuration: .default)
    let dataTask: URLSessionDataTask = session.dataTask(with: url){(data: Data?, response: URLResponse?, error: Error?) in
        if let error = error{
            print(error.localizedDescription)
            return
        }
        
        guard let data = data else{ return }
        do{
            let response: Villager = try JSONDecoder().decode(Villager.self, from: data)
            //result전달
            NotificationCenter.default.post(name: Notification.Name("ReceviedVillagerInfo"), object: nil, userInfo: ["villager":response])
            
        }catch(let err){
            print(err.localizedDescription)
        }
    }
    dataTask.resume()
}
