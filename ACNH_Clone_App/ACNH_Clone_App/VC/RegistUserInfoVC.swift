//
//  RegistUserInfoVC.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/08/31.
//

import UIKit

class RegistUserInfoVC: UIViewController {
    let fruits = ["", "사과", "배", "오렌지", "복숭아", "체리"]
    let area = ["", "북반구", "남반구"]
    var fruitName: String = ""
    var areaName: String = ""
    
    let labelStackView = UIStackView()
    let labelOne = UILabel()
    let labelTwo = UILabel()
    let labelThree = UILabel()
    let labelFour = UILabel()
    let labelFive = UILabel()
    let labelSix = UILabel()
    let userNameField = UITextField()
    let islandNameField = UITextField()
    let friendCodeField = UITextField()
    let dreamCodeField = UITextField()
    let fruitView = UIView()
    let areaView = UIView()
    let saveButton = UIButton()
    let fruitButton = UIButton()
    let fruitRightBtn = UIButton()
    let areaButton = UIButton()
    let areaRightBtn = UIButton()
    let fruitsTableView = UITableView()
    let areaTableView = UITableView()
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGesture(_:)))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadUserData()
    }
    
    func loadUserData(){
        if !sharedData.st.userName.isEmpty {
            userNameField.text = sharedData.st.userName
        }
        
        if !sharedData.st.userIslandName.isEmpty {
            islandNameField.text = sharedData.st.userIslandName
        }
        
        if !sharedData.st.userFriendsCode.isEmpty {
            friendCodeField.text = sharedData.st.userFriendsCode
        }
        
        if !sharedData.st.userDreamCode.isEmpty {
            dreamCodeField.text = sharedData.st.userDreamCode
        }
        
        if !sharedData.st.userFruit.isEmpty {
            fruitName = sharedData.st.userFruit
            fruitButton.setTitle(fruitName, for: .normal)
        }
        
        if !sharedData.st.userArea.isEmpty {
            areaName = sharedData.st.userArea
            areaButton.setTitle(areaName, for: .normal)
        }
    }
}

//MARK: @objc
extension RegistUserInfoVC{
    @objc func didTapGesture(_ sender: UITapGestureRecognizer){
        print(#function)
        self.view.endEditing(true)
        fruitsTableView.isHidden = true
        areaTableView.isHidden = true
    }
    @objc func openFruitTable(_ sender: UIButton){
        print(#function)
        self.view.endEditing(true)
        fruitsTableView.isHidden = false
        areaTableView.isHidden = true
    }
    @objc func openAreaTable(_ sender: UIButton){
        print(#function)
        self.view.endEditing(true)
        areaTableView.isHidden = false
        fruitsTableView.isHidden = true
    }
    @objc func didTapSaveBtn(_ sender: UIButton){
        print(#function)
        if !userNameField.text!.isEmpty {
            sharedData.st.userName = userNameField.text!
            UserDefaults.standard.set(sharedData.st.userName, forKey: "UserName")
        }else{
            sharedData.st.userName = ""
            UserDefaults.standard.removeObject(forKey: "UserName")
        }
        if !islandNameField.text!.isEmpty {
            sharedData.st.userIslandName = islandNameField.text!
            UserDefaults.standard.set(sharedData.st.userIslandName, forKey: "UserIslandName")
        }else{
            sharedData.st.userIslandName = ""
            UserDefaults.standard.removeObject(forKey: "UserIslandName")
        }
        if !friendCodeField.text!.isEmpty {
            sharedData.st.userFriendsCode = friendCodeField.text!
            UserDefaults.standard.set(sharedData.st.userFriendsCode, forKey: "UserFriendCode")
        }else{
            sharedData.st.userFriendsCode = ""
            UserDefaults.standard.removeObject(forKey: "UserFriendCode")
        }
        if !dreamCodeField.text!.isEmpty {
            sharedData.st.userDreamCode = dreamCodeField.text!
            UserDefaults.standard.set(sharedData.st.userDreamCode, forKey: "UserDreamCode")
        }else{
            sharedData.st.userDreamCode = ""
            UserDefaults.standard.removeObject(forKey: "UserDreamCode")
        }
        if !fruitName.isEmpty {
            sharedData.st.userFruit = fruitName
            UserDefaults.standard.set(sharedData.st.userFruit, forKey: "UserFruit")
        }else{
            sharedData.st.userFruit = ""
            UserDefaults.standard.removeObject(forKey: "UserFruit")
        }
        if !areaName.isEmpty {
            sharedData.st.userArea = areaName
            UserDefaults.standard.set(sharedData.st.userArea, forKey: "UserArea")
        }else{
            sharedData.st.userArea = ""
            UserDefaults.standard.removeObject(forKey: "UserArea")
        }
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: TextFieldDelegate
extension RegistUserInfoVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 8.093491488e-05, green: 0.5098327994, blue: 0.9449871778, alpha: 1)
        fruitsTableView.isHidden = true
        areaTableView.isHidden = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
}

//MARK: TableViewDataSource
extension RegistUserInfoVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == fruitsTableView {
            return fruits.count
        }
        else{
            return area.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView{
        case fruitsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "fruitCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = fruits[indexPath.row]
            content.textProperties.font = UIFont.systemFont(ofSize: 12)
            cell.contentConfiguration = content
            cell.backgroundColor = #colorLiteral(red: 0.9601849914, green: 0.9601849914, blue: 0.9601849914, alpha: 1)
            return cell
        case areaTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "areaCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = area[indexPath.row]
            content.textProperties.font = UIFont.systemFont(ofSize: 12)
            cell.contentConfiguration = content
            cell.backgroundColor = #colorLiteral(red: 0.9601849914, green: 0.9601849914, blue: 0.9601849914, alpha: 1)
            return cell
        default:
            fatalError()
        }
    }
}

//MARK: TableViewDelegate
extension RegistUserInfoVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView{
        case fruitsTableView:
            self.fruitButton.setTitle(fruits[indexPath.row], for: .normal)
            fruitName = fruits[indexPath.row]
        case areaTableView:
            self.areaButton.setTitle(area[indexPath.row], for: .normal)
            areaName = area[indexPath.row]
        default:
            fatalError()
        }
    }
}

//MARK: - UI
extension RegistUserInfoVC{
    private func setNavigation(){
        self.navigationController?.navigationBar.layer.cornerRadius = 20
        self.navigationController?.navigationBar.clipsToBounds = true
        self.navigationController?.navigationBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.title = "My Profile"
        self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.4469897747, green: 0.7176824212, blue: 0.8038204312, alpha: 1)
    }
    private func setUI(){
        labelOne.text = "이름"
        labelTwo.text = "섬 이름"
        labelThree.text = "친구코드"
        labelFour.text = "꿈번지"
        labelFive.text = "과일 종류"
        labelSix.text = "북반구/남반구"
        labelOne.font = UIFont.systemFont(ofSize: 12)
        labelTwo.font = UIFont.systemFont(ofSize: 12)
        labelThree.font = UIFont.systemFont(ofSize: 12)
        labelFour.font = UIFont.systemFont(ofSize: 12)
        labelFive.font = UIFont.systemFont(ofSize: 12)
        labelSix.font = UIFont.systemFont(ofSize: 12)
        
        tapGesture.cancelsTouchesInView = false
        
        labelStackView.addArrangedSubview(labelOne)
        labelStackView.addArrangedSubview(labelTwo)
        labelStackView.addArrangedSubview(labelThree)
        labelStackView.addArrangedSubview(labelFour)
        labelStackView.addArrangedSubview(labelFive)
        labelStackView.addArrangedSubview(labelSix)
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.distribution = .equalSpacing
        labelStackView.spacing = 50
        
        [userNameField, islandNameField, friendCodeField, dreamCodeField].forEach{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            $0.layer.cornerRadius = 10
            $0.addLeftPadding()
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.placeholder = "정보를 입력해주세요."
            $0.delegate = self
        }
        [fruitView, areaView].forEach{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            $0.layer.cornerRadius = 10
        }
        fruitButton.setTitle("", for: .normal)
        fruitButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        fruitButton.contentHorizontalAlignment = .left
        fruitButton.setTitleColor(.black, for: .normal)
        fruitButton.addTarget(self, action: #selector(openFruitTable(_:)), for: .touchUpInside)
        fruitRightBtn.setTitle("▼", for: .normal)
        fruitRightBtn.setTitleColor(.black, for: .normal)
        fruitRightBtn.titleLabel?.font = .systemFont(ofSize: 10)
        fruitRightBtn.addTarget(self, action: #selector(openFruitTable(_:)), for: .touchUpInside)
        areaButton.setTitle("", for: .normal)
        areaButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        areaButton.contentHorizontalAlignment = .left
        areaButton.setTitleColor(.black, for: .normal)
        areaButton.addTarget(self, action: #selector(openAreaTable(_:)), for: .touchUpInside)
        areaRightBtn.setTitle("▼", for: .normal)
        areaRightBtn.setTitleColor(.black, for: .normal)
        areaRightBtn.titleLabel?.font = .systemFont(ofSize: 10)
        areaRightBtn.addTarget(self, action: #selector(openAreaTable(_:)), for: .touchUpInside)
        
        saveButton.setTitle("저장", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        saveButton.tintColor = .white
        saveButton.backgroundColor = #colorLiteral(red: 0.086937357, green: 0.7382838961, blue: 0.5775274772, alpha: 1)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(didTapSaveBtn(_:)), for: .touchUpInside)
        
        fruitsTableView.isScrollEnabled = false
        areaTableView.isScrollEnabled = false
        fruitsTableView.dataSource = self
        fruitsTableView.delegate = self
        areaTableView.dataSource = self
        areaTableView.delegate = self
        fruitsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "fruitCell")
        areaTableView.register(UITableViewCell.self, forCellReuseIdentifier: "areaCell")
        fruitsTableView.isHidden = true
        areaTableView.isHidden = true
        
        view.addSubview(labelStackView)
        view.addGestureRecognizer(tapGesture)
        view.addSubview(userNameField)
        view.addSubview(islandNameField)
        view.addSubview(friendCodeField)
        view.addSubview(dreamCodeField)
        view.addSubview(fruitView)
        fruitView.addSubview(fruitButton)
        fruitView.addSubview(fruitRightBtn)
        view.addSubview(areaView)
        areaView.addSubview(areaButton)
        areaView.addSubview(areaRightBtn)
        view.addSubview(saveButton)
        view.addSubview(fruitsTableView)
        view.addSubview(areaTableView)
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        islandNameField.translatesAutoresizingMaskIntoConstraints = false
        dreamCodeField.translatesAutoresizingMaskIntoConstraints = false
        friendCodeField.translatesAutoresizingMaskIntoConstraints = false
        fruitView.translatesAutoresizingMaskIntoConstraints = false
        fruitButton.translatesAutoresizingMaskIntoConstraints = false
        fruitRightBtn.translatesAutoresizingMaskIntoConstraints = false
        areaView.translatesAutoresizingMaskIntoConstraints = false
        areaButton.translatesAutoresizingMaskIntoConstraints = false
        areaRightBtn.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        fruitsTableView.translatesAutoresizingMaskIntoConstraints = false
        areaTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            labelStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            userNameField.heightAnchor.constraint(equalToConstant: 40),
            islandNameField.heightAnchor.constraint(equalToConstant: 40),
            dreamCodeField.heightAnchor.constraint(equalToConstant: 40),
            friendCodeField.heightAnchor.constraint(equalToConstant: 40),
            fruitView.heightAnchor.constraint(equalToConstant: 40),
            areaView.heightAnchor.constraint(equalToConstant: 40),
            userNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            userNameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            userNameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            islandNameField.leadingAnchor.constraint(equalTo: userNameField.leadingAnchor),
            islandNameField.trailingAnchor.constraint(equalTo: userNameField.trailingAnchor),
            islandNameField.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 25),
            friendCodeField.leadingAnchor.constraint(equalTo: userNameField.leadingAnchor),
            friendCodeField.trailingAnchor.constraint(equalTo: userNameField.trailingAnchor),
            friendCodeField.topAnchor.constraint(equalTo: islandNameField.bottomAnchor, constant: 25),
            dreamCodeField.leadingAnchor.constraint(equalTo: userNameField.leadingAnchor),
            dreamCodeField.trailingAnchor.constraint(equalTo: userNameField.trailingAnchor),
            dreamCodeField.topAnchor.constraint(equalTo: friendCodeField.bottomAnchor, constant: 25),
            fruitView.leadingAnchor.constraint(equalTo: userNameField.leadingAnchor),
            fruitView.trailingAnchor.constraint(equalTo: userNameField.trailingAnchor),
            fruitView.topAnchor.constraint(equalTo: dreamCodeField.bottomAnchor, constant: 25),
            areaView.leadingAnchor.constraint(equalTo: userNameField.leadingAnchor),
            areaView.trailingAnchor.constraint(equalTo: userNameField.trailingAnchor),
            areaView.topAnchor.constraint(equalTo: fruitView.bottomAnchor, constant: 25),
            saveButton.topAnchor.constraint(equalTo: areaView.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 35),
            fruitRightBtn.topAnchor.constraint(equalTo: fruitView.topAnchor),
            fruitRightBtn.bottomAnchor.constraint(equalTo: fruitView.bottomAnchor),
            fruitRightBtn.trailingAnchor.constraint(equalTo: fruitView.trailingAnchor),
            fruitRightBtn.widthAnchor.constraint(equalToConstant: 50),
            fruitButton.topAnchor.constraint(equalTo: fruitView.topAnchor),
            fruitButton.bottomAnchor.constraint(equalTo: fruitView.bottomAnchor),
            fruitButton.leadingAnchor.constraint(equalTo: fruitView.leadingAnchor, constant: 10),
            fruitButton.trailingAnchor.constraint(equalTo: fruitRightBtn.leadingAnchor),
            areaRightBtn.topAnchor.constraint(equalTo: areaView.topAnchor),
            areaRightBtn.bottomAnchor.constraint(equalTo: areaView.bottomAnchor),
            areaRightBtn.trailingAnchor.constraint(equalTo: areaView.trailingAnchor),
            areaRightBtn.widthAnchor.constraint(equalToConstant: 50),
            areaButton.topAnchor.constraint(equalTo: areaView.topAnchor),
            areaButton.bottomAnchor.constraint(equalTo: areaView.bottomAnchor),
            areaButton.leadingAnchor.constraint(equalTo: areaView.leadingAnchor, constant: 10),
            areaButton.trailingAnchor.constraint(equalTo: areaRightBtn.leadingAnchor),
            fruitsTableView.topAnchor.constraint(equalTo: fruitView.topAnchor),
            fruitsTableView.leadingAnchor.constraint(equalTo: fruitView.leadingAnchor),
            fruitsTableView.trailingAnchor.constraint(equalTo: fruitView.trailingAnchor),
            fruitsTableView.heightAnchor.constraint(equalToConstant: 210),
            areaTableView.topAnchor.constraint(equalTo: areaView.topAnchor),
            areaTableView.leadingAnchor.constraint(equalTo: areaView.leadingAnchor),
            areaTableView.trailingAnchor.constraint(equalTo: areaView.trailingAnchor),
            areaTableView.heightAnchor.constraint(equalToConstant: 105)
        ])
    }
}

