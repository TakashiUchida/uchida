//
//  MemberData.swift
//  MyOkashi
//
//  Created by User5 on 2018/03/08.
//  Copyright © 2018年 User5. All rights reserved.
//

import Foundation

class MemberData: NSObject, NSCoding {
    
    var userLastName: String
    var userFirstName: String
    var email: String
    var password: String
    var birthday: String?   //必須項目ではないのでオプショナル型にする
    
    //イニシャライザ
    init(userLastName: String, userFirstName: String, email: String, password: String, birthday: String?) {
        
        self.userLastName = userLastName
        self.userFirstName = userFirstName
        self.email = email
        self.password = password
        self.birthday = birthday
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(userLastName, forKey: "userLastName")
        aCoder.encode(userFirstName, forKey: "userFirstName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(birthday, forKey: "birthday")

    }
    
    required init?(coder aDecoder: NSCoder) {

        //必須項目は強制的アンラップ（【aDecoder.decodeObject】がnilになる可能性があるためオプショナル型）
        self.userLastName = aDecoder.decodeObject(forKey: "userLastName") as! String
        self.userFirstName = aDecoder.decodeObject(forKey: "userFirstName") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.password = aDecoder.decodeObject(forKey: "password") as! String
        self.birthday = aDecoder.decodeObject(forKey: "birthday") as? String
    
    }
    
    
}
