//
//  UserDefault.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/27.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation

//初回起動確認
class FirstViewCheck {
    let firstViewValue = UserDefaults.standard
    
    func CheckFirstView() -> (Bool){
        firstViewValue.register(defaults: ["firstView": true])
        let checkValue = firstViewValue.object(forKey: "firstView") as! Bool
        print("firstView -> \(checkValue)")
        
        return checkValue
    }
    
    func FalseFirstView() {
        firstViewValue.set(false, forKey: "firstView")
    }
}

//Twitterの認証キー
class TwitterKeys {
    let twitterKeyValue = UserDefaults.standard
    
    func GetValue() -> (String, String) {
        twitterKeyValue.register(defaults: ["tokenKey": "key"])
        twitterKeyValue.register(defaults: ["secretKey": "secret"])
        
        let token = twitterKeyValue.object(forKey: "tokenKey") as! String
        let secret = twitterKeyValue.object(forKey: "secretKey") as! String
        
        return (token, secret)
    }
    
    func SaveValue(token: String, secret: String) {
        twitterKeyValue.set(token, forKey: "tokenKey")
        twitterKeyValue.set(secret, forKey: "secretKey")
        
    }
}

//カテゴリー一覧
class ViewCategory{
    let categoryValue = UserDefaults.standard
    
    func GetValue() -> ([String]) {
        categoryValue.register(defaults: ["viewValue": ["value"]])
        
        let viewValueArray = categoryValue.object(forKey: "viewValue") as! [String]
        
        return (viewValueArray)
    }
    
    func SaveValue(array: [String]) {
        categoryValue.set(array, forKey: "viewValue")
    }
}
