//
//  Login_APIrequest_Backup_ViewController.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/24.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit
import Firebase
import OAuthSwift

class Login_APIrequest_Backup_ViewController: UIViewController {
    
    var provider: OAuthProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewController")
        
        //Twitter
        provider = OAuthProvider(providerID: "twitter.com")
        //Twitterログイン処理
        SigninWithTwitter()
    }
    
    //Twitterへのログイン処理
    func SigninWithTwitter() {
        
        provider?.getCredentialWith(nil, completion: { credential, error in
            if error != nil {
                print("Error Handring")
            }
            
            if credential != nil {
                Auth.auth().signIn(with: credential!, completion: { authResult, error in
                    if error != nil {
                        print("error Handring")
                    }
                    if let credential = authResult?.credential as? OAuthCredential,
                        let token = credential.accessToken,
                        let secret = credential.secret {
                        print("accessToken = \(token)")
                        print("secret = \(secret)")
                        self.ShowTimeLine(accessToken: token, secret: secret)
                    }
                })
            }
        })
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
    
    func ShowTimeLine(accessToken: String, secret: String) {
        let comsumerKey = "2H2A7Ej1g4WBimFP4V888reYG"
        let comsumerSecret = "wHfBRX9bXBtqBmDKxwzfCHcLVFkegX5Ry0mnt5GSsvGEqA5Xts"
        
        guard let url = URL(string: "https://api.twitter.com/1.1/account/settings.json") else {
            print("Get setting error")
            return
        }
        
        guard let favUrl = URL(string: "https://api.twitter.com/1.1/favorites/list.json") else {
            print("Get favorite error")
            return
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
                    print("GetSetting_Decode Error")
                    return
                }
                
                print(setting.screenName)
                
                //ユーザーの設定が正常に取得できたらユーザーのいいね欄を取得
                //パラメータをセット（必要なパラメータはTwitter Developerのサイトに記載あり）
                //screen_name -> ユーザーID（自分のID）、　count -> 200が最大
                let paramater: OAuthSwift.ConfigParameters = ["screen_name":setting.screenName, "count":"1000"]
                
                client.get(favUrl, parameters: paramater, headers: nil, completionHandler: { favResult in
                    switch favResult {
                    case .success(let favResponse):
                        
                        guard let favoriteListViewer = try? JSONDecoder().decode([Favorite].self, from: favResponse.data) else {
                            print("GetFavorite_Decode Error")
                            return
                        }
                        print("fav_success")
                        for i in 0 ..< favoriteListViewer.count {
                            print(favoriteListViewer[i].text)
                        }
                    
                    case .failure:
                        print("fav_failure")
                        break
                    }
                })
                
            case .failure:
                break
            }
        })
    }
    /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */

}

