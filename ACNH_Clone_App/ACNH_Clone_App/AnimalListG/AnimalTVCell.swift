//
//  AnimalTVCell.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/07/30.
//

import UIKit

class AnimalTVCell: UITableViewCell {

    @IBOutlet weak var animalNum: UILabel!
    @IBOutlet weak var animalProfile: UIImageView!
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var animalFeature: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func homeBtnClicked(_ sender: UIButton) {
        guard let numberID = Int(animalNum.text!) else{return}
        if sharedData.st.villagersInMyIsland.contains(numberID){
            if let idx = sharedData.st.villagersInMyIsland.firstIndex(of: numberID){
                sharedData.st.villagersInMyIsland.remove(at: idx)
                sharedData.st.nameInMyIsland.remove(at: idx)
                DispatchQueue.main.async(execute: {
                    sharedData.st.iconInMyIsland.remove(at: idx)
                    UserDefaults.standard.set(sharedData.st.iconInMyIsland, forKey: "MyIslandIcon")
                })
            }
            homeBtn.tintColor = .lightGray
            NotificationCenter.default.post(name: Notification.Name("updateMyIslandCollection"), object: nil)
            UserDefaults.standard.set(sharedData.st.villagersInMyIsland, forKey: "MyIslandId")
            UserDefaults.standard.set(sharedData.st.nameInMyIsland, forKey: "MyIslandName")
        }
        else{
            if sharedData.st.villagersInMyIsland.count < 10{
                sharedData.st.villagersInMyIsland.append(numberID)
                sharedData.st.nameInMyIsland.append(animalName.text!)
                DispatchQueue.main.async {
                    guard let iconURL: URL = URL(string: URL.villagerIcon(numberID))else{return}
                    guard let iconData: Data = try? Data(contentsOf: iconURL)else{return}
                    sharedData.st.iconInMyIsland.append(iconData)
                    UserDefaults.standard.set(sharedData.st.iconInMyIsland, forKey: "MyIslandIcon")
                }
                
                homeBtn.tintColor = .green
                NotificationCenter.default.post(name: Notification.Name("updateMyIslandCollection"), object: nil)
                UserDefaults.standard.set(sharedData.st.villagersInMyIsland, forKey: "MyIslandId")
                UserDefaults.standard.set(sharedData.st.nameInMyIsland, forKey: "MyIslandName")
            }
            else{
                NotificationCenter.default.post(name: Notification.Name("failToAddMyIsland"), object: nil, userInfo: nil)
            }
        }
    }
    @IBAction func favoriteBtnClicked(_ sender: UIButton) {
        guard let numberID = Int(animalNum.text!) else{return}
        if sharedData.st.villagersInMyFavorite.contains(numberID){
            if let idx = sharedData.st.villagersInMyFavorite.firstIndex(of: numberID){
                sharedData.st.villagersInMyFavorite.remove(at: idx)
                sharedData.st.nameInMyFavorite.remove(at: idx)
                DispatchQueue.main.async(execute: {
                    sharedData.st.iconInMyFavorite.remove(at: idx)
                    UserDefaults.standard.set(sharedData.st.iconInMyFavorite, forKey: "MyFavoriteIcon")
                })
            }
            favoriteBtn.tintColor = .lightGray
        }
        else{
            sharedData.st.villagersInMyFavorite.append(numberID)
            sharedData.st.nameInMyFavorite.append(animalName.text!)
            DispatchQueue.main.async {
                guard let iconURL: URL = URL(string: URL.villagerIcon(numberID))else{return}
                guard let iconData: Data = try? Data(contentsOf: iconURL)else{return}
                sharedData.st.iconInMyFavorite.append(iconData)
                UserDefaults.standard.set(sharedData.st.iconInMyFavorite, forKey: "MyFavoriteIcon")
            }
            
            favoriteBtn.tintColor = .red
        }
        NotificationCenter.default.post(name: Notification.Name("updateMyFavoriteCollection"), object: nil)
        UserDefaults.standard.set(sharedData.st.villagersInMyFavorite, forKey: "MyFavoriteId")
        UserDefaults.standard.set(sharedData.st.nameInMyFavorite, forKey: "MyFavoriteName")
    }
    
}
