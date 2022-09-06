//
//  SingletonData.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/07/25.
//

import Foundation
import UIKit

class sharedData{
    static let st: sharedData = sharedData()
    
    var darkMode: Bool = false
    
//MARK: - Home
    var villagersInMyIsland = [Int]()
    var iconInMyIsland = [Data]()
    var nameInMyIsland = [String]()
    var villagersInMyFavorite = [Int]()
    var iconInMyFavorite = [Data]()
    var nameInMyFavorite = [String]()
    
//MARK: - USER
    var userName: String = ""
    var userIslandName: String = ""
    var userFriendsCode: String = ""
    var userDreamCode: String = ""
    var userFruit: String = "" // 과일/사과/배/오렌지/복숭아/체리
    var userArea: String = "" // 지형/북반구/남반구
    
//MARK: - Villagers
    var receivedVillagers = [Villager]()
    var villagersDictionaryImg = [String:UIImage]()
    
    var sortType = false
    var villageGender = 0
    var villageSpecies = 0
    var villagePersonality = 0
    
    let genderArr = ["성별", "남", "여"]
    let speciesArr = ["종", "개", "개구리", "개미핥기", "고릴라", "고양이", "늑대", "다람쥐", "닭", "독수리", "돼지", "말", "문어", "사슴", "사자", "새", "생쥐", "수소", "아기곰", "악어", "암소", "양", "염소", "오리", "원숭이", "캥거루", "코끼리", "코뿔소", "코알라", "큰곰", "타조", "토끼", "팽귄", "하마", "햄스터", "호랑이"]
    let personalityArr = ["성격", "느끼함", "단순활발", "먹보", "무뚝뚝", "성숙함", "아이돌", "운동광", "친절함"]
    let genderKo = [
        "Male": "남",
        "Female": "여"
    ]
    let speciesKo = [
        "Dog" : "개",
        "Frog" : "개구리",
        "Anteater" : "개미핥기",
        "Gorilla" : "고릴라",
        "Cat" : "고양이",
        "Wolf" : "늑대",
        "Squirrel" : "다람쥐",
        "Chicken" : "닭",
        "Eagle" : "독수리",
        "Pig" : "돼지",
        "Horse" : "말",
        "Octopus" : "문어",
        "Deer" : "사슴",
        "Lion" : "사자",
        "Bird" : "새",
        "Mouse" : "생쥐",
        "Bull" : "수소",
        "Cub" : "아기곰",
        "Alligator" : "악어",
        "Cow" : "암소",
        "Sheep" : "양",
        "Goat" : "염소",
        "Duck" : "오리",
        "Monkey" : "원숭이",
        "Kangaroo" : "캥거루",
        "Elephant" : "코끼리",
        "Rhino" : "코뿔소",
        "Koala" : "코알라",
        "Bear" : "큰곤",
        "Ostrich" : "타조",
        "Rabbit" : "토끼",
        "Penguin" : "팽귄",
        "Hippo" : "하마",
        "Hamster" : "햄스터",
        "Tiger" : "호랑이"
    ]
    let personalityKo = [
        "Smug" : "느끼함",
        "Uchi" : "단순활발",
        "Lazy" : "먹보",
        "Cranky" : "무뚝뚝",
        "Snooty" : "성숙함",
        "Peppy" : "아이돌",
        "Jock" : "운동광",
        "Normal" : "친절함"
    ]
    
}

extension Dictionary where Value: Equatable{
    func keyByValue(_ value: Value) -> [Key]{
        return flatMap{ (key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
}
