//
//  VillagersListMultiVC.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/08/07.
//
import UIKit

class VillagersListMultiVC: UIViewController {
    var numberOfVillagerVC: Int = 0
    var titleText: String!
    let sortByArr = ["오름차순", "내림차순"]
    var filteredVillagers = [Villager]()
    var tableOutput = [Villager]()
    var isLoading = false{
        didSet{
            self.indicatorView.isHidden = !self.isLoading
            self.isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    lazy var sortMenuBar = UIView()
    lazy var firstSortBtn = UIButton()
    lazy var secondSortBtn = UIButton()
    lazy var thirdSortBtn = UIButton()
    lazy var fourthSortBtn = UIButton()
    lazy var sortStackView = UIStackView()
    lazy var animalTableView = UITableView()
    lazy var sortByType = UITableView()
    lazy var sortByGender = UITableView()
    lazy var sortBySpecies = UITableView()
    lazy var sortByPersonality = UITableView()
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
    lazy var gestureView = UIView()
    lazy var searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(tapRightBarBtn(_:)))
    lazy var cancelItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tapRightBarBtn(_:)))
    lazy var searchField = UISearchBar()
    lazy var titleField = UILabel()
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
//MARK: - LC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setUI()
        setTableView()
        setTableView()
        setJsonData()
        isLoading = false
        
        //NotificationObserver
        NotificationCenter.default.addObserver(self, selector: #selector(self.failAlert(_:)), name: Notification.Name("failToAddMyIsland"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFromNoti(_:)), name: Notification.Name("updateMyIslandCollection"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFromNoti(_:)), name: Notification.Name("updateMyFavoriteCollection"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.4476694465, green: 0.7179295421, blue: 0.803657949, alpha: 1)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = #colorLiteral(red: 0.4476694465, green: 0.7179295421, blue: 0.803657949, alpha: 1)
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = #colorLiteral(red: 0.4476694465, green: 0.7179295421, blue: 0.803657949, alpha: 1)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: TableView DataSource
extension VillagersListMultiVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case animalTableView:
            return tableOutput.count
        case sortByType:
            return sortByArr.count
        case sortByGender:
            return sharedData.st.genderArr.count
        case sortBySpecies:
            return sharedData.st.speciesArr.count
        case sortByPersonality:
            return sharedData.st.personalityArr.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case animalTableView:
            guard let cell: AnimalTVCell = tableView.dequeueReusableCell(withIdentifier: "animalListCell", for: indexPath) as? AnimalTVCell else{return UITableViewCell()}
            let index: Int = sharedData .st.sortType ? tableOutput.count - 1 - indexPath.row : indexPath.row
            
            cell.selectionStyle = .none
            cell.animalNum.text = String(format: "%03d",tableOutput[index].id)
            cell.animalName.text = tableOutput[index].name.nameKRko
            cell.animalFeature.text = tableOutput[index].featureStr
            
            if let existImg = sharedData.st.villagersDictionaryImg[String(self.tableOutput[index].id)] {
                cell.animalProfile.image = existImg
            }else{
                self.isLoading = true
                DispatchQueue.global().async {
                    guard let profileURL: URL = URL(string: URL.villagerProfile(self.tableOutput[index].id))else{return}
                    guard let profileData: Data = try? Data(contentsOf: profileURL)else{return}
//                    if let img = UIImage(data: profileData) {
//                        sharedData.st.villagersDictionaryImg[String(self.tableOutput[index].id)] = img
//                        cell.animalProfile.image = img
//                    }
                    guard let img = UIImage(data: profileData) else{return}
                    let render = UIGraphicsImageRenderer(size: CGSize(width: 70, height: 70))
                    let renderImage = render.image{ context in
                        img.draw(in: CGRect(origin: .zero, size: CGSize(width: 70, height: 70)))
                    }
                    sharedData.st.villagersDictionaryImg[String(self.tableOutput[index].id)] = renderImage
                    DispatchQueue.main.async {
                        cell.animalProfile.image = renderImage
                    }
                    DispatchQueue.main.async(execute: {self.isLoading = false})
                }
            }
                
            if sharedData.st.villagersInMyIsland.contains(tableOutput[index].id){
                cell.homeBtn.tintColor = .green
            }else{
                cell.homeBtn.tintColor = .lightGray
            }
            if sharedData.st.villagersInMyFavorite.contains(tableOutput[index].id){
                cell.favoriteBtn.tintColor = .red
            }else{
                cell.favoriteBtn.tintColor = .lightGray
            }
            
            return cell
        case sortByType:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "seasonCell", for: indexPath)
            cell.textLabel?.text = sortByArr[indexPath.row]
            cell.textLabel?.font = .boldSystemFont(ofSize: 10)
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
            return cell
        case sortByGender:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "genderCell", for: indexPath)
            cell.textLabel?.text = sharedData.st.genderArr[indexPath.row]
            cell.textLabel?.font = .boldSystemFont(ofSize: 10)
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
            return cell
        case sortBySpecies:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath)
            cell.textLabel?.text = sharedData.st.speciesArr[indexPath.row]
            cell.textLabel?.font = .boldSystemFont(ofSize: 10)
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
            return cell
        case sortByPersonality:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)
            cell.textLabel?.text = sharedData.st.personalityArr[indexPath.row]
            cell.textLabel?.font = .boldSystemFont(ofSize: 10)
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
            return cell
        default:
            return UITableViewCell()
        }
    }
}
//MARK: TableView Delegate
extension VillagersListMultiVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case animalTableView:
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VillagerInfoSB") as? VillagerInfoVC else{return}
            let index: Int = sharedData .st.sortType ? tableOutput.count - 1 - indexPath.row : indexPath.row
            nextVC.villagerId = tableOutput[index].id
            self.navigationItem.backBarButtonItem?.tintColor = .black
            self.navigationController?.navigationBar.standardAppearance.backgroundColor = .white
            self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .white
            self.navigationController?.pushViewController(nextVC, animated: true)
        case sortByType:
            sharedData.st.sortType = indexPath.row == 0 ? false : true
            sortByType.isHidden = true
            firstSortBtn.setTitle(sortByArr[indexPath.row] + "  ▼", for: .normal)
            gestureView.isHidden = true
            animalTableView.reloadData()
        case sortByGender:
            sharedData.st.villageGender = indexPath.row
            sortByGender.isHidden = true
            secondSortBtn.setTitle(sharedData.st.genderArr[indexPath.row] + "  ▼", for: .normal)
            filteredVillagers = villagersFilter(sharedData.st.receivedVillagers, numberOfVillagerVC)
            tableOutput = villagersSearched(filteredVillagers, searchField.text!)
            gestureView.isHidden = true
            animalTableView.reloadData()
        case sortBySpecies:
            sharedData.st.villageSpecies = indexPath.row
            sortBySpecies.isHidden = true
            thirdSortBtn.setTitle(sharedData.st.speciesArr[indexPath.row] + "  ▼", for: .normal)
            filteredVillagers = villagersFilter(sharedData.st.receivedVillagers, numberOfVillagerVC)
            tableOutput = villagersSearched(filteredVillagers, searchField.text!)
            gestureView.isHidden = true
            animalTableView.reloadData()
        case sortByPersonality:
            sharedData.st.villagePersonality = indexPath.row
            sortByPersonality.isHidden = true
            fourthSortBtn.setTitle(sharedData.st.personalityArr[indexPath.row] + "  ▼", for: .normal)
            filteredVillagers = villagersFilter(sharedData.st.receivedVillagers, numberOfVillagerVC)
            tableOutput = villagersSearched(filteredVillagers, searchField.text!)
            gestureView.isHidden = true
            animalTableView.reloadData()
        default:
            print("Not Exist Table View")
        }
    }
}

//MARK: SearchBarDelegate
extension VillagersListMultiVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()  //diissmiss keyboard
        gestureView.isHidden = true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        sortByType.isHidden = true
        sortByGender.isHidden = true
        sortBySpecies.isHidden = true
        sortByPersonality.isHidden = true
        gestureView.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableOutput = villagersSearched(filteredVillagers, searchBar.text!)
        animalTableView.reloadData()
    }
}

//MARK: - Function
extension VillagersListMultiVC{
    @objc func tapView(_ sender: UITapGestureRecognizer){
        print("TapGesture")
        sortByType.isHidden = true
        sortByGender.isHidden = true
        sortBySpecies.isHidden = true
        sortByPersonality.isHidden = true
        gestureView.isHidden = true
        searchField.endEditing(true)
    }
    @objc func tapRightBarBtn(_ sender: UIBarButtonItem){
        switch sender {
        case searchItem:
            navigationItem.rightBarButtonItem = cancelItem
            navigationItem.titleView = searchField
            searchField.becomeFirstResponder()
            sortByType.isHidden = true
            sortByGender.isHidden = true
            sortBySpecies.isHidden = true
            sortByPersonality.isHidden = true
            gestureView.isHidden = false
        case cancelItem:
            searchField.text = ""
            navigationItem.rightBarButtonItem = searchItem
            navigationItem.titleView = titleField
            sortByType.isHidden = true
            sortByGender.isHidden = true
            sortBySpecies.isHidden = true
            sortByPersonality.isHidden = true
            gestureView.isHidden = true
            tableOutput = filteredVillagers
            animalTableView.reloadData()
            
        default:
            fatalError()
        }
    }
    @objc func TouchFirstSortMenu(_ sender: UIButton) {
        if sortByType.isHidden {
            sortByType.isHidden = false
            sortByGender.isHidden = true
            sortBySpecies.isHidden = true
            sortByPersonality.isHidden = true
            gestureView.isHidden = false
        }
    }
    @objc func TouchSecondSortMenu(_ sender: UIButton) {
        if sortByGender.isHidden {
            sortByGender.isHidden = false
            sortByType.isHidden = true
            sortBySpecies.isHidden = true
            sortByPersonality.isHidden = true
            gestureView.isHidden = false
        }
    }
    @objc func TouchThirdSortMenu(_ sender: UIButton) {
        if sortBySpecies.isHidden {
            sortBySpecies.isHidden = false
            sortByType.isHidden = true
            sortByGender.isHidden = true
            sortByPersonality.isHidden = true
            gestureView.isHidden = false
        }
    }
    @objc func TouchFourthSortMenu(_ sender: UIButton) {
        if sortByPersonality.isHidden {
            sortByPersonality.isHidden = false
            sortByType.isHidden = true
            sortByGender.isHidden = true
            sortBySpecies.isHidden = true
            gestureView.isHidden = false
        }
    }
    
    @objc func failAlert(_ noti: Notification){
        self.present(UIAlertController.overVillagers(), animated: true, completion: nil)
    }
    
    @objc func updateFromNoti(_ noti: Notification){
        animalTableView.reloadData()
    }
}

extension VillagersListMultiVC{
    //sort func
    func villagersFilter(_ villagersList: [Villager], _ type: Int) -> [Villager] {
        var temp = [Villager]()
        switch type{
        case 0:
            temp = villagersList
        case 1:
            temp = homeFilter(villagersList)
        case 2:
            temp = favoriteFilter(villagersList)
        default:
            print("errror")
        }
        var result = [Villager]()
        for idx in 0..<temp.count{
            var genderBool = false
            var speciesBool = false
            var personalBool = false
            
            let genderOption = sharedData.st.villageGender
            genderBool = genderOption == 0 ? true : temp[idx].gender == sharedData.st.genderKo.keyByValue(sharedData.st.genderArr[genderOption]).first ? true : false
            let speciesOption = sharedData.st.villageSpecies
            speciesBool = speciesOption == 0 ? true : temp[idx].species == sharedData.st.speciesKo.keyByValue(sharedData.st.speciesArr[speciesOption]).first ? true : false
            let personalOption = sharedData.st.villagePersonality
            personalBool = personalOption == 0 ? true : temp[idx].personality == sharedData.st.personalityKo.keyByValue(sharedData.st.personalityArr[personalOption]).first ? true : false
            
            if genderBool && speciesBool && personalBool {
                result.append(temp[idx])
            }
        }
        return result
    }
    //search func
    func villagersSearched(_ villagersList: [Villager], _ searchText: String) -> [Villager]{
        var result = [Villager]()
        if searchText.count == 0{
            result = villagersList
        }
        else{
            for idx in 0..<villagersList.count {
                if villagersList[idx].name.nameKRko.contains(searchText){
                    result.append(filteredVillagers[idx])
                }
            }
        }
        return result
    }
    //sort for numVC
    func homeFilter(_ villagersList: [Villager]) -> [Villager] {
        var result = [Villager]()
        for idx in 0..<villagersList.count{
            if sharedData.st.villagersInMyIsland.contains(villagersList[idx].id) {
                result.append(villagersList[idx])
            }
        }
        return result
    }
    func favoriteFilter(_ villagersList: [Villager]) -> [Villager] {
        var result = [Villager]()
        for idx in 0..<villagersList.count{
            if sharedData.st.villagersInMyFavorite.contains(villagersList[idx].id) {
                result.append(villagersList[idx])
            }
        }
        return result
    }
}

//MARK: - setViewDidLoad
extension VillagersListMultiVC{
    private func setNavigation(){
        titleField.text = titleText
        titleField.textColor = UIColor.white
        navigationItem.titleView = titleField
        if numberOfVillagerVC == 0{
            navigationItem.rightBarButtonItem = searchItem
        }
        navigationController?.navigationBar.tintColor = UIColor.white
        
      //BackButton Setup
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "")
        self.navigationItem.backBarButtonItem?.tintColor = .black
    }
    private func setUI(){
        //translatesAutoresizingMaskIntoConstraints
        sortMenuBar.translatesAutoresizingMaskIntoConstraints = false
        if numberOfVillagerVC == 0{
            firstSortBtn.translatesAutoresizingMaskIntoConstraints = false
        }
        secondSortBtn.translatesAutoresizingMaskIntoConstraints = false
        thirdSortBtn.translatesAutoresizingMaskIntoConstraints = false
        fourthSortBtn.translatesAutoresizingMaskIntoConstraints = false
        sortStackView.translatesAutoresizingMaskIntoConstraints = false
        animalTableView.translatesAutoresizingMaskIntoConstraints = false
        sortByType.translatesAutoresizingMaskIntoConstraints = false
        sortByGender.translatesAutoresizingMaskIntoConstraints = false
        sortBySpecies.translatesAutoresizingMaskIntoConstraints = false
        sortByPersonality.translatesAutoresizingMaskIntoConstraints = false
        gestureView.translatesAutoresizingMaskIntoConstraints = false
        
        //addSubview
        view.addSubview(sortMenuBar)
        sortMenuBar.addSubview(sortStackView)
        view.addSubview(animalTableView)
        view.addSubview(gestureView)
        gestureView.addGestureRecognizer(tapGesture)
        view.addSubview(sortByGender)
        view.addSubview(sortBySpecies)
        view.addSubview(sortByPersonality)
        if numberOfVillagerVC == 0 {
            view.addSubview(sortByType)
            sortStackView.addArrangedSubview(firstSortBtn)
        }
        sortStackView.addArrangedSubview(secondSortBtn)
        sortStackView.addArrangedSubview(thirdSortBtn)
        sortStackView.addArrangedSubview(fourthSortBtn)
        
        //AutoLayout
        if numberOfVillagerVC == 0 {
            NSLayoutConstraint.activate([
                firstSortBtn.widthAnchor.constraint(equalToConstant: 60),
                sortByType.topAnchor.constraint(equalTo: firstSortBtn.topAnchor),
                sortByType.leadingAnchor.constraint(equalTo: firstSortBtn.leadingAnchor),
                sortByType.widthAnchor.constraint(equalToConstant: 70),
                sortByType.heightAnchor.constraint(equalToConstant: 90)
            ])
        }
        NSLayoutConstraint.activate([
            sortMenuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sortMenuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sortMenuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sortMenuBar.heightAnchor.constraint(equalToConstant: 37),
            sortStackView.topAnchor.constraint(equalTo: sortMenuBar.topAnchor, constant: 5),
            sortStackView.leadingAnchor.constraint(equalTo: sortMenuBar.leadingAnchor, constant: 20),
            sortStackView.trailingAnchor.constraint(equalTo: sortMenuBar.trailingAnchor, constant: -20),
            secondSortBtn.widthAnchor.constraint(equalToConstant: 60),
            thirdSortBtn.widthAnchor.constraint(equalToConstant: 60),
            fourthSortBtn.widthAnchor.constraint(equalToConstant: 60),
            animalTableView.topAnchor.constraint(equalTo: sortMenuBar.bottomAnchor),
            animalTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animalTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animalTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sortByGender.leadingAnchor.constraint(equalTo: secondSortBtn.leadingAnchor),
            sortByGender.topAnchor.constraint(equalTo: secondSortBtn.topAnchor),
            sortByGender.widthAnchor.constraint(equalToConstant: 50),
            sortByGender.heightAnchor.constraint(equalToConstant: 130),
            sortBySpecies.topAnchor.constraint(equalTo: thirdSortBtn.topAnchor),
            sortBySpecies.centerXAnchor.constraint(equalTo: thirdSortBtn.centerXAnchor),
            sortBySpecies.widthAnchor.constraint(equalToConstant: 70),
            sortBySpecies.heightAnchor.constraint(equalToConstant: (view.frame.height) * 4 / 5),
            sortByPersonality.topAnchor.constraint(equalTo: fourthSortBtn.topAnchor),
            sortByPersonality.trailingAnchor.constraint(equalTo: fourthSortBtn.trailingAnchor),
            sortByPersonality.widthAnchor.constraint(equalToConstant: 70),
            sortByPersonality.heightAnchor.constraint(equalToConstant: 400),
            gestureView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gestureView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gestureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gestureView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        //Attribute
        sortMenuBar.backgroundColor = #colorLiteral(red: 0.4476694465, green: 0.7179295421, blue: 0.803657949, alpha: 1)
        sortMenuBar.layer.cornerRadius = 20
        sortMenuBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        sortMenuBar.layer.borderWidth = 0
        sortMenuBar.layer.masksToBounds = false
        sortMenuBar.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        sortMenuBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        sortMenuBar.layer.shadowOpacity = 0.8
        sortStackView.axis = .horizontal
        sortStackView.distribution = .equalSpacing
        sortStackView.alignment = .center
        firstSortBtn.titleLabel?.font = .systemFont(ofSize: 12)
        secondSortBtn.titleLabel?.font = .systemFont(ofSize: 12)
        thirdSortBtn.titleLabel?.font = .systemFont(ofSize: 12)
        fourthSortBtn.titleLabel?.font = .systemFont(ofSize: 12)
        sortByType.backgroundColor = UIColor.darkGray
        sortByType.alpha = 0.8
        sortByGender.backgroundColor = UIColor.darkGray
        sortByGender.alpha = 0.8
        sortBySpecies.backgroundColor = UIColor.darkGray
        sortBySpecies.alpha = 0.8
        sortByPersonality.backgroundColor = UIColor.darkGray
        sortByPersonality.alpha = 0.8
        gestureView.backgroundColor = .clear
        indicatorView.layer.cornerRadius = 10
        searchField.searchTextField.clearButtonMode = .never
        searchField.searchTextField.textColor = UIColor.white
        searchField.searchTextField.leftView?.tintColor = UIColor.white
        
        firstSortBtn.setTitle(sortByArr[0] + "  ▼", for: .normal)
        secondSortBtn.setTitle(sharedData.st.genderArr[0] + "  ▼", for: .normal)
        thirdSortBtn.setTitle(sharedData.st.speciesArr[0] + "  ▼", for: .normal)
        fourthSortBtn.setTitle(sharedData.st.personalityArr[0] + "  ▼", for: .normal)
        firstSortBtn.addTarget(self, action: #selector(TouchFirstSortMenu), for: .touchUpInside)
        secondSortBtn.addTarget(self, action: #selector(TouchSecondSortMenu), for: .touchUpInside)
        thirdSortBtn.addTarget(self, action: #selector(TouchThirdSortMenu), for: .touchUpInside)
        fourthSortBtn.addTarget(self, action: #selector(TouchFourthSortMenu), for: .touchUpInside)
        sharedData.st.sortType = false
        sharedData.st.villageGender = 0
        sharedData.st.villageSpecies = 0
        sharedData.st.villagePersonality = 0
        sortByType.isHidden = true
        sortByGender.isHidden = true
        sortBySpecies.isHidden = true
        sortByPersonality.isHidden = true
        gestureView.isHidden = true
        view.bringSubviewToFront(indicatorView)  //indicatorView move to Front
        
        //Delegate, DataSource
        animalTableView.dataSource = self
        animalTableView.delegate = self
        sortByType.dataSource = self
        sortByType.delegate = self
        sortByGender.dataSource = self
        sortByGender.delegate = self
        sortBySpecies.dataSource = self
        sortBySpecies.delegate = self
        sortByPersonality.dataSource = self
        sortByPersonality.delegate = self
        searchField.delegate = self
    }
    private func setTableView(){
        animalTableView.register(UINib(nibName: "AnimalTVCell", bundle: nil), forCellReuseIdentifier: "animalListCell")
        sortByType.register(UITableViewCell.self, forCellReuseIdentifier: "seasonCell")
        sortByGender.register(UITableViewCell.self, forCellReuseIdentifier: "genderCell")
        sortBySpecies.register(UITableViewCell.self, forCellReuseIdentifier: "typeCell")
        sortByPersonality.register(UITableViewCell.self, forCellReuseIdentifier: "characterCell")
    }
    private func setJsonData(){
        //JSON Decoder
        //guard sharedData.st.receivedVillagers.count > 1 else{
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "villagers") else{return}
        do{
            let receivedJson: VillagerResponse = try JSONDecoder().decode(VillagerResponse.self, from: dataAsset.data)
            sharedData.st.receivedVillagers = receivedJson.villagers
        } catch{ print(error.localizedDescription)}
        
        filteredVillagers = villagersFilter(sharedData.st.receivedVillagers, numberOfVillagerVC)
        tableOutput = filteredVillagers
    }
}
