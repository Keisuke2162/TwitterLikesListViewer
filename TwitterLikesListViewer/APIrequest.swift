//
//  APIrequest.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/24.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit
import Firebase
import OAuthSwift

class APIRequest {
    
    var likesText: [String] = []
    
    //returnValue
    var returnKey: Bool = false
    var returnToken: String = ""
    var returnSecret: String = ""
    
    var provider: OAuthProvider?
     //Twitterへのログイン処理
    func SigninWithTwitter() -> (Bool, String, String) {
        
        //Twitter
        provider = OAuthProvider(providerID: "twitter.com")
            
        provider?.getCredentialWith(nil, completion: { credential, error in
            if error != nil {
                print("Error : GET Credential")
                //Error時はFalseリターン
                self.returnKey = false
            }
            
            if credential != nil {
                Auth.auth().signIn(with: credential!, completion: { authResult, error in
                    if error != nil {
                        print("Error : Authentication")
                        //Error時はFalseリターン
                        self.returnKey = false
                    }
                    if let credential = authResult?.credential as? OAuthCredential,
                        let token = credential.accessToken,
                        let secret = credential.secret {
                        print("accessToken = \(token)")
                        print("secret = \(secret)")
                        
                        //トークン、シークレットキー情報を更新
                        self.returnToken = token
                        self.returnSecret = secret
                        self.returnKey = true
                        //self.ShowTimeLine(accessToken: token, secret: secret)
                    }
                })
            }
        })
        //ログイン処理の結果、トークン、シークレットキーを返却
        return (returnKey, returnToken, returnSecret)
    }
        
    //取得データはめる
    struct TwitterSetting: Decodable {
        let language: String
        let screenName: String
        
        enum CodingKeys: String, CodingKey {
            case language = "language"
            case screenName = "screen_name"
        }
    }

    struct Favorite: Decodable {
        let created: String
        let id_str: String
        let text: String
        //let user: User
        /*
        struct User: Decodable {
            let id_str: String
            let name: String
            let screen_name: String
            let url: String
        }
        */
        enum CodingKeys: String, CodingKey {
            case created = "created_at"
            case id_str = "id_str"
            case text = "text"
            //case user = "user"
        }
        
    }
    

    var returnResult: Bool = false
    var timeLineArray: [String] = []
        
    func ShowTimeLine(accessToken: String, secret: String) -> (Bool, [String]) {
        
        let comsumerKey = "2H2A7Ej1g4WBimFP4V888reYG"
        let comsumerSecret = "wHfBRX9bXBtqBmDKxwzfCHcLVFkegX5Ry0mnt5GSsvGEqA5Xts"
        
        guard let url = URL(string: "https://api.twitter.com/1.1/account/settings.json") else {
            print("Error : GET SettingURL")
            returnResult = false
            return (returnResult,timeLineArray)
        }
        
        guard let favUrl = URL(string: "https://api.twitter.com/1.1/favorites/list.json") else {
            print("Error : GET favoriteURL")
            returnResult = false
            return (returnResult, timeLineArray)
        }
        
        let client = OAuthSwiftClient(
            consumerKey: comsumerKey,
            consumerSecret: comsumerSecret,
            oauthToken: accessToken,
            oauthTokenSecret: secret,
            version: .oauth1
        )
        
        //ユーザーの設定を取得
        client.get(url, completionHandler: { result in
            switch result {
            case .success(let response):
                print(response.data.count)
                
                guard let setting = try? JSONDecoder().decode(TwitterSetting.self, from: response.data) else {
                    print("Error : SettingResult Decode")
                    self.returnResult = false
                    return
                }
                
                print(setting.screenName)
                
                //ユーザーの設定が正常に取得できたらユーザーのいいね欄を取得
                //パラメータをセット（必要なパラメータはTwitter Developerのサイトに記載あり）
                //screen_name -> ユーザーID（自分のID）、　count -> 200が最大
                //var sinceValue: Int = 0
                let paramater: OAuthSwift.ConfigParameters = ["screen_name":setting.screenName, "count":"1000"]
                
                client.get(favUrl, parameters: paramater, headers: nil, completionHandler: { favResult in
                    switch favResult {
                    case .success(let favResponse):
                        
                        guard let favoriteListViewer = try? JSONDecoder().decode([Favorite].self, from: favResponse.data) else {
                            print("Error : FavoriteResult Decode")
                            self.returnResult = false
                            return
                        }
                        
                        for i in 0 ..< favoriteListViewer.count {
                            print(favoriteListViewer[i].text)
                            
                            //ツイートのテキストを配列に格納
                            self.timeLineArray.append(favoriteListViewer[i].text)
                        }
                        
                        self.returnResult = true
                    
                    case .failure:
                        print("Error : GET FavoriteResult")
                        self.returnResult = false
                        break
                    }
                })
                
            case .failure:
                print("Error : GET SettingResult")
                self.returnResult = false
                break
            }
        })
        
        //処理結果、タイムライン情報配列を戻り値に
        return (returnResult, timeLineArray)
    }
}
