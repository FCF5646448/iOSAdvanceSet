import UIKit

var greeting = "Hello, playground"
/*
{
    "menu" {
        "id": "file"
        "value": 1,
        "popup": {
            "menu_item": [
                {
                    "value": "new",
                    "onclick": "CreateNewDoc()"
                },
                {
                    "value": "open",
                    "onclick": "openDoc()"
                },
                {
                    "value": "close",
                    "onclick": "closeDoc()"
                }
            ]
        }
    }
}
*/

struct Obj: Codable {
    let menu: Menu
    struct Menu: Codable {
        let id: String
        let value: Int
        let popup: Popup
    }
    
    struct Popup: Codable {
        let menuItem: [MenuItem]
        enum CodingKeys: String, CodingKey {
            case menuItem = "menu_item"
        }
    }
    
    struct MenuItem: Codable {
        let value: String
        let onClick: String
        
        enum CodingKeys: String, CodingKey {
            case value
            case onClick = "onclick"
        }
    }
}

let data = "jsonString".data(using: .utf8)
do {
    let obj: Obj = try JSONDecoder().decode(Obj.self, from: data!)
    print(obj.menu.popup.menuItem.first?.value)
} catch {
    print("error")
}
