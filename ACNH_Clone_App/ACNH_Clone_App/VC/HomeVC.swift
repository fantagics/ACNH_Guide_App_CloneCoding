//
//  ViewController.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/07/12.
//

import UIKit

class HomeVC: UIViewController {
    let sideWidth: CGFloat = 200
    var sideIsVisable = false
    var isOpen = [true, true, true]
    let homeSection = ["우리 섬 주민", "내 선호 주민", "달성도"]
    
    let rightSideView = UIView()
    let fruitIconItem = UIButton()
    let areaIconItem = UIButton()
    
    //MARK: - @IBOutlet
    @IBOutlet weak var sideBackView: UIView!
    @IBOutlet weak var sideLeading: NSLayoutConstraint!
    @IBOutlet weak var homeTableView: UITableView!
    
    //MARK: - LC
    override func viewDidLoad() {
        super.viewDidLoad()
      //BackButton Setup
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "")
        
      //sideMenu
        sideBackView.isHidden = true
        sideBackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
        sideBackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackView(_:))))
        
      //homeView
        homeTableView.delegate = self
        homeTableView.dataSource = self
      //Header
        homeTableView.tableHeaderView = Bundle.main.loadNibNamed("HomeTableHeader", owner: self, options: nil)?.last as? UIView
        homeTableView.tableHeaderView?.frame.size.height = CGFloat(200)
      //Sectioin
        homeTableView.register(UINib(nibName: "HomeSectionHeaderA", bundle: nil), forHeaderFooterViewReuseIdentifier: "customHomeHeaderA")
        homeTableView.register(UINib(nibName: "HomeSectionHeaderB", bundle: nil), forHeaderFooterViewReuseIdentifier: "customHomeHeaderB")
      //cell
        homeTableView.register(UINib(nibName: "HomeCellIsland", bundle: nil), forCellReuseIdentifier: "cellMyIsland")
        homeTableView.register(UINib(nibName: "HomeCellFavority", bundle: nil), forCellReuseIdentifier: "cellMyFavorite")
        homeTableView.rowHeight = UITableView.automaticDimension
        
      //Load Villagers JSON
        
      //Load UserDefaults
        loadUserVillagers()
        loadUserInfomation()
        setRightNavigation()
        
      //Notification
        NotificationCenter.default.addObserver(self, selector: #selector(showUpdateUserData(_:)), name: Notification.Name("tableHeaderRequest"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //BackButton Setup
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = #colorLiteral(red: 0.4469897747, green: 0.7176824212, blue: 0.8038204312, alpha: 1)
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = #colorLiteral(red: 0.4469897747, green: 0.7176824212, blue: 0.8038204312, alpha: 1)
        self.navigationController?.navigationBar.layer.cornerRadius = 0
        loadNavigationItem()
        
        homeTableView.reloadData()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
//MARK: - @IBAction
    @IBAction func tapedSideBtn(_ sender: UIBarButtonItem) {
        func activity(){
            if !sideIsVisable {
                sideLeading.constant = 0
                sideBackView.isHidden = false
                sideBackView.alpha = 0.8
                sideIsVisable = true
            }
            else{
                sideLeading.constant = -sideWidth
                sideBackView.isHidden = true
                sideIsVisable = false
            }
        }
        
        //animation
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            activity()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

//MARK: TableView DataSource
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isOpen.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isOpen[section] ? 1 : 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0, 1:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customHomeHeaderA") as? HomeSectionHeaderA else{return UITableViewHeaderFooterView()}

            headerView.isOpened = isOpen[section]
            headerView.sectionIndex = section
            headerView.sectionTitle.text = homeSection[section]
            headerView.delegate = self

            return headerView

        case 2:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customHomeHeaderB") as? HomeSectionHeaderB else{return UITableViewHeaderFooterView()}

            headerView.sectionTitle.text = homeSection[section]
            headerView.realtimeFarmingBtn.layer.cornerRadius = 7

            return headerView

        default:
            print("Not Found SectionView")
            return UITableViewHeaderFooterView()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            guard let cell: HomeCellIsland = tableView.dequeueReusableCell(withIdentifier: "cellMyIsland", for: indexPath) as? HomeCellIsland else{return UITableViewCell()}
            cell.delegate = self
            return cell
        case 1:
            guard let cell: HomeCellFavority = tableView.dequeueReusableCell(withIdentifier: "cellMyFavorite", for: indexPath) as? HomeCellFavority else{return UITableViewCell()}
            cell.delegate = self
            return cell
//        case 2:
//            guard let cell: HomeCellIsland = tableView.dequeueReusableCell(withIdentifier: "cellMyIsland", for: indexPath) as? HomeCellIsland else{return UITableViewCell()}
//            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension HomeVC: UITableViewDelegate{
    
}

//MARK: func
extension HomeVC{
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer){
        let translationX: CGFloat = sender.translation(in: sender.view).x
        
        switch sender.state {
        case .began:
            print("PanGesture Began")
        case .changed:
            if -translationX <= sideWidth && -translationX > -1{
                self.sideLeading.constant = translationX
                self.sideBackView.alpha = (200+translationX) / 250
            }
        case .ended:
            if -translationX > (sideWidth/2) {
                self.sideLeading.constant = -sideWidth
                self.sideBackView.isHidden = true
                sideIsVisable = false
            }
            else{
                self.sideLeading.constant = 0
                self.sideBackView.alpha = 0.8
            }
        default:
            break
        }
    }
    
    @objc func tapBackView(_ sender: UITapGestureRecognizer){
        func activity(){
            self.sideLeading.constant = -sideWidth
            self.sideBackView.isHidden = true
            sideIsVisable = false
        }
        //animation
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            activity()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func showUpdateUserData(_ noti: Notification) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistUserDataSB") as? RegistUserInfoVC else{return}
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func loadUserVillagers(){
        print(#function)
        if let received = UserDefaults.standard.object(forKey: "MyIslandId") as? [Int]{
            sharedData.st.villagersInMyIsland = received
        }
        if let received = UserDefaults.standard.object(forKey: "MyIslandName") as? [String]{
            sharedData.st.nameInMyIsland = received
        }
        if let received = UserDefaults.standard.object(forKey: "MyIslandIcon") as? [Data]{
            sharedData.st.iconInMyIsland = received
        }
        if let received = UserDefaults.standard.object(forKey: "MyFavoriteId") as? [Int]{
            sharedData.st.villagersInMyFavorite = received
        }
        if let received = UserDefaults.standard.object(forKey: "MyFavoriteName") as? [String]{
            sharedData.st.nameInMyFavorite = received
        }
        if let received = UserDefaults.standard.object(forKey: "MyFavoriteIcon") as? [Data]{
            sharedData.st.iconInMyFavorite = received
        }
    }
    func loadUserInfomation(){
        print(#function)
        if let received = UserDefaults.standard.string(forKey: "UserName"){
            sharedData.st.userName = received
        }
        if let received = UserDefaults.standard.string(forKey: "UserIslandName"){
            sharedData.st.userIslandName = received
        }
        if let received = UserDefaults.standard.string(forKey: "UserFriendCode"){
            sharedData.st.userFriendsCode = received
        }
        if let received = UserDefaults.standard.string(forKey: "UserDreamCode"){
            sharedData.st.userDreamCode = received
        }
        if let received = UserDefaults.standard.string(forKey: "UserFruit"){
            sharedData.st.userFruit = received
        }
        if let received = UserDefaults.standard.string(forKey: "UserArea"){
            sharedData.st.userArea = received
        }
    }
    
    func loadNavigationItem(){
        if sharedData.st.userFruit.count > 0 {
            switch sharedData.st.userFruit {
            case "사과":
                fruitIconItem.setImage(UIImage(named: "appleIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
            case "배":
                fruitIconItem.setImage(UIImage(named: "pearIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
            case "오렌지":
                fruitIconItem.setImage(UIImage(named: "orangeIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
            case "복숭아":
                fruitIconItem.setImage(UIImage(named: "peachIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
            case "체리":
                fruitIconItem.setImage(UIImage(named: "cherryIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
            default:
                print("Not Exist Fruit")
            }
        }
        else{
            fruitIconItem.setImage(nil, for: .normal)
        }
        if sharedData.st.userArea.count > 0 {
            switch sharedData.st.userArea {
            case "북반구":
                areaIconItem.setImage(UIImage(named: "northIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
            case "남반구":
                areaIconItem.setImage(UIImage(named: "southIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
            default:
                print("Not Exist Area")
            }
        }
        else{
            areaIconItem.setImage(nil, for: .normal)
        }
    }
    
    func setRightNavigation(){
        rightSideView.translatesAutoresizingMaskIntoConstraints = false
        rightSideView.heightAnchor.constraint(equalToConstant: 37).isActive = true
        rightSideView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        rightSideView.addSubview(fruitIconItem)
        rightSideView.addSubview(areaIconItem)
        fruitIconItem.translatesAutoresizingMaskIntoConstraints = false
        areaIconItem.translatesAutoresizingMaskIntoConstraints = false
        areaIconItem.trailingAnchor.constraint(equalTo: rightSideView.trailingAnchor).isActive = true
        areaIconItem.centerYAnchor.constraint(equalTo: rightSideView.centerYAnchor).isActive = true
        areaIconItem.heightAnchor.constraint(equalToConstant: 30).isActive = true
        areaIconItem.widthAnchor.constraint(equalToConstant: 30).isActive = true
        fruitIconItem.leadingAnchor.constraint(equalTo: rightSideView.leadingAnchor).isActive = true
        fruitIconItem.topAnchor.constraint(equalTo: rightSideView.topAnchor).isActive = true
        fruitIconItem.bottomAnchor.constraint(equalTo: rightSideView.bottomAnchor).isActive = true
        fruitIconItem.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        let rightViewItem = UIBarButtonItem(customView: rightSideView)
        self.navigationItem.rightBarButtonItem = rightViewItem
    }
}

//MARK: Delegate
extension HomeVC: HomeSectionHeaderDelegate{
    func didTapSection(_ sectionIndex: Int) {
        isOpen[sectionIndex].toggle()
        homeTableView.reloadData()
    }
}
extension HomeVC: HomeCollectionCellDelegate{
    func didTapVillagerCell(_ villagerId: Int) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VillagerInfoSB") as? VillagerInfoVC else{return}
        nextVC.villagerId = villagerId
        self.navigationItem.backBarButtonItem?.tintColor = .black
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = .white
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .white
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

