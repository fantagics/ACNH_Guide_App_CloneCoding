//
//  villagersModel.swift
//  ACNH_Clone_App
//
//  Created by 이태형 on 2022/07/30.
//

import Foundation

struct VillagerResponse: Codable{
    let villagers: [Villager]
}

struct Villager: Codable{
    let id: Int
    let fileName: String
    let name: nameLanguage
    let personality: String
    let birthdayString: String
    let birthday: String
    let species: String
    let gender: String
    let subtype: String
    let hobby: String
    let catchPhrase: String
    let iconUri: String
    let imageUri: String
    let bubbleColor: String
    let textColor: String
    let saying: String
    let catchTranslations: catchLanguage
    
    struct nameLanguage: Codable{
        let nameUSen: String
        let nameEUen: String
        let nameEUde: String
        let nameEUes: String
        let nameUSes: String
        let nameEUfr: String
        let nameUSfr: String
        let nameEUit: String
        let nameEUnl: String
        let nameCNzh: String
        let nameTWzh: String
        let nameJPja: String
        let nameKRko: String
        let nameEUru: String
        
        enum CodingKeys: String, CodingKey{
            case nameUSen = "name-USen"
            case nameEUen = "name-EUen"
            case nameEUde = "name-EUde"
            case nameEUes = "name-EUes"
            case nameUSes = "name-USes"
            case nameEUfr = "name-EUfr"
            case nameUSfr = "name-USfr"
            case nameEUit = "name-EUit"
            case nameEUnl = "name-EUnl"
            case nameCNzh = "name-CNzh"
            case nameTWzh = "name-TWzh"
            case nameJPja = "name-JPja"
            case nameKRko = "name-KRko"
            case nameEUru = "name-EUru"
        }
    }
    struct catchLanguage: Codable{
        let catchUSen: String
        let catchEUen: String
        let catchEUde: String
        let catchEUes: String
        let catchUSes: String
        let catchEUfr: String
        let catchUSfr: String
        let catchEUit: String
        let catchEUnl: String
        let catchCNzh: String
        let catchTWzh: String
        let catchJPja: String
        let catchKRko: String
        let catchEUru: String
        
        enum CodingKeys: String, CodingKey{
            case catchUSen = "catch-USen"
            case catchEUen = "catch-EUen"
            case catchEUde = "catch-EUde"
            case catchEUes = "catch-EUes"
            case catchUSes = "catch-USes"
            case catchEUfr = "catch-EUfr"
            case catchUSfr = "catch-USfr"
            case catchEUit = "catch-EUit"
            case catchEUnl = "catch-EUnl"
            case catchCNzh = "catch-CNzh"
            case catchTWzh = "catch-TWzh"
            case catchJPja = "catch-JPja"
            case catchKRko = "catch-KRko"
            case catchEUru = "catch-EUru"
        }
    }
    enum CodingKeys: String, CodingKey{
        case id
        case fileName = "file-name"
        case name, personality
        case birthdayString = "birthday-string"
        case birthday
        case species, gender, subtype, hobby
        case catchPhrase = "catch-phrase"
        case iconUri = "icon_uri"
        case imageUri = "image_uri"
        case bubbleColor = "bubble-color"
        case textColor = "text-color"
        case saying
        case catchTranslations = "catch-translations"
    }
    
    var featureStr: String{
        let genderKo = sharedData.st.genderKo[self.gender]
        let speciesKo = sharedData.st.speciesKo[self.species]
        let personalityKo = sharedData.st.personalityKo[self.personality]
        
        return genderKo! + " / " + speciesKo! + " / " + personalityKo!
    }
}

/* let speciesArr = ["종", "개", "개구리", "개미핥기", "고릴라", "고양이", "늑대", "다람쥐", "닭", "독수리", "돼지"]
 {
     "id": 1,
     "file-name": "ant00",
     "name": {
         "name-USen": "Cyrano",
         "name-EUen": "Cyrano",
         "name-EUde": "Theo",
         "name-EUes": "Cirano",
         "name-USes": "Cirano",
         "name-EUfr": "Cyrano",
         "name-USfr": "Cyrano",
         "name-EUit": "Cirano",
         "name-EUnl": "Cyrano",
         "name-CNzh": "阳明",
         "name-TWzh": "陽明",
         "name-JPja": "さくらじま",
         "name-KRko": "사지마",
         "name-EUru": "Сирано"
     },
     "personality": "Cranky",
     "birthday-string": "March 9th",
     "birthday": "9/3",
     "species": "Anteater",
     "gender": "Male",
     "subtype": "B",
     "hobby": "Education",
     "catch-phrase": "ah-CHOO",
     "icon_uri": "https://acnhapi.com/v1/icons/villagers/1",
     "image_uri": "https://acnhapi.com/v1/images/villagers/1",
     "bubble-color": "#194c89",
     "text-color": "#fffad4",
     "saying": "Don't punch your nose to spite your face.",
     "catch-translations": {
         "catch-USen": "ah-CHOO",
         "catch-EUen": "ah-CHOO",
         "catch-EUde": "schneuf",
         "catch-EUes": "achús",
         "catch-USes": "achús",
         "catch-EUfr": "ATCHOUM",
         "catch-USfr": "ATCHOUM",
         "catch-EUit": "ett-CCIÙ",
         "catch-EUnl": "ha-TSJOE",
         "catch-CNzh": "有的",
         "catch-TWzh": "有的",
         "catch-JPja": "でごわす",
         "catch-KRko": "임돠",
         "catch-EUru": "апчхи"
     }
 }
 */
