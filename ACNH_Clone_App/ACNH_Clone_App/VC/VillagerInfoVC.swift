//
//  VillagerInfoVC.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/08/06.
//

import UIKit

class VillagerInfoVC: UIViewController {
    var villagerId = 1
    var isLoading = false{
        didSet{
            self.indicatorView.isHidden = !self.isLoading
            self.isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    //MARK: - @IBOutlet
    @IBOutlet weak var villagerNameLabel: UILabel!
    @IBOutlet weak var genderSymbolIV: UIImageView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var personalityLabel: UILabel!
    @IBOutlet weak var villagerProfileIV: UIImageView!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var hobbyLabel: UILabel!
    @IBOutlet weak var catchLabel: UILabel!
    @IBOutlet weak var textColorIV: UIImageView!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var amiiboIdLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: - LC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        self.isLoading = true
        requestVillager(villagerId)
        
        //NotifiCation Observer
        NotificationCenter.default.addObserver(self, selector: #selector(receiveVillager(_:)), name: Notification.Name("ReceviedVillagerInfo"), object: nil)
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - @IBAction
    @IBAction func homeBtnClicked(_ sender: UIButton) {
        if sharedData.st.villagersInMyIsland.contains(villagerId){
            if let idx = sharedData.st.villagersInMyIsland.firstIndex(of: villagerId){
                sharedData.st.villagersInMyIsland.remove(at: idx)
                sharedData.st.nameInMyIsland.remove(at: idx)
                DispatchQueue.global().async(execute: {
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
                sharedData.st.villagersInMyIsland.append(villagerId)
                sharedData.st.nameInMyIsland.append(villagerNameLabel.text!)
                DispatchQueue.global().async {
                    guard let iconURL: URL = URL(string: URL.villagerIcon(self.villagerId))else{return}
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
                self.present(UIAlertController.overVillagers(), animated: true, completion: nil)
            }
        }
    }
    @IBAction func favoriteBtnClicked(_ sender: UIButton) {
        if sharedData.st.villagersInMyFavorite.contains(villagerId){
            if let idx = sharedData.st.villagersInMyFavorite.firstIndex(of: villagerId){
                sharedData.st.villagersInMyFavorite.remove(at: idx)
                sharedData.st.nameInMyFavorite.remove(at: idx)
                DispatchQueue.global().async(execute: {
                    sharedData.st.iconInMyFavorite.remove(at: idx)
                    UserDefaults.standard.set(sharedData.st.iconInMyFavorite, forKey: "MyFavoriteIcon")
                })
            }
            favoriteBtn.tintColor = .lightGray
        }
        else{
            sharedData.st.villagersInMyFavorite.append(villagerId)
            sharedData.st.nameInMyFavorite.append(villagerNameLabel.text!)
            DispatchQueue.global().async {
                guard let iconURL: URL = URL(string: URL.villagerIcon(self.villagerId))else{return}
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

//MARK: - function
extension VillagerInfoVC{
    @objc func receiveVillager(_ sender: Notification){
        guard let villagerInfo: Villager = sender.userInfo?["villager"] as? Villager else{return}
        print("THREAD : \(Thread.isMainThread)")
        DispatchQueue.main.async {
            self.villagerNameLabel.text = villagerInfo.name.nameKRko
            self.personalityLabel.text = sharedData.st.personalityKo[villagerInfo.personality]
            self.speciesLabel.text = sharedData.st.speciesKo[villagerInfo.species]
            self.hobbyLabel.text = villagerInfo.hobby
            self.catchLabel.text = villagerInfo.catchTranslations.catchKRko
            self.birthdayLabel.text = villagerInfo.birthdayString
            self.amiiboIdLabel.text = String(villagerInfo.id)
            
            if sharedData.st.villagersInMyIsland.contains(self.villagerId){
                self.homeBtn.tintColor = .green
            }else{
                self.homeBtn.tintColor = .lightGray
            }
            if sharedData.st.villagersInMyFavorite.contains(self.villagerId){
                self.favoriteBtn.tintColor = .red
            }else{
                self.favoriteBtn.tintColor = .lightGray
            }
            self.textColorIV.backgroundColor = self.hexStringToUIColor(hex: villagerInfo.textColor)
            self.genderSymbolIV.image = villagerInfo.gender == "Male" ? UIImage(named: "maleIcon_s") : UIImage(named: "femaleIcon_s")
        }
        DispatchQueue.global().async {
            guard let profileURL: URL = URL(string: villagerInfo.imageUri)else{return}
            guard let profileData: Data = try? Data(contentsOf: profileURL)else{return}
            guard let img = UIImage(data: profileData) else{return}
            DispatchQueue.main.async {
                self.villagerProfileIV.image = img
            }
            DispatchQueue.main.async(execute: {self.isLoading = false})
        }
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension VillagerInfoVC{
    private func setUI(){
        navigationController?.navigationBar.backgroundColor = UIColor.white
        
        homeBtn.layer.cornerRadius = homeBtn.frame.width / 2
        homeBtn.layer.borderWidth = 0
        homeBtn.layer.masksToBounds = false
        homeBtn.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        homeBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        homeBtn.layer.shadowOpacity = 0.7
        favoriteBtn.layer.cornerRadius = favoriteBtn.frame.width / 2
        favoriteBtn.layer.borderWidth = 0
        favoriteBtn.layer.masksToBounds = false
        favoriteBtn.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        favoriteBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        favoriteBtn.layer.shadowOpacity = 0.7
        textColorIV.layer.cornerRadius = 4
        textColorIV.layer.borderWidth = 1
        textColorIV.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        villagerProfileIV.layer.cornerRadius = 10
        indicatorView.layer.cornerRadius = 10
    }
}
