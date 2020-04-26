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

class Login_APIrequest_Backup_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var provider: OAuthProvider?
    
    var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewController")
        
        //Twitter
        provider = OAuthProvider(providerID: "twitter.com")
        //Twitterログイン処理
        SigninWithTwitter()
        
        //tableView描画
        self.tableView = UITableView()
        self.tableView.frame = self.view.frame
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "timeLineCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //self.tableView.estimatedRowHeight = 500
        //self.tableView.rowHeight = UITableView.automaticDimension
        
        
        /*
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(TableRefresh), for: .valueChanged)
        self.tableView.refreshControl = refresh
        */
    }
    
    /*
    @objc func TableRefresh() {
        ShowTimeLine(accessToken: commonToken, secret: commonSecret)
        
        tableView.reloadData()
    }
    
    var commonToken: String = ""
    var commonSecret: String = ""
    
    */
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
                        //self.commonToken = token
                        //self.commonSecret = secret
                        print("accessToken = \(token)")
                        print("secret = \(secret)")
                        self.ShowTimeLine(accessToken: token, secret: secret)
                    }
                })
            }
        })
    }
    

    
    //var twitterCellText: [String] = []
    var favoriteList: [Favorite] = []
    
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
                let paramater: OAuthSwift.ConfigParameters = ["screen_name":setting.screenName, "count":"200"]
                
                client.get(favUrl, parameters: paramater, headers: nil, completionHandler: { favResult in
                    switch favResult {
                    case .success(let favResponse):
                        
                        DispatchQueue.main.async {
                            guard let favoriteListViewer = try? JSONDecoder().decode([Favorite].self, from: favResponse.data) else {
                                print("GetFavorite_Decode Error")
                                return
                            }
                            print("fav_success")
                            
                            /*
                            //いいね欄のツイートを一つずつ配列に格納
                            for i in 0 ..< favoriteListViewer.count {
                                print("name = \(favoriteListViewer[i].user.name)")
                                print("screenname = \(favoriteListViewer[i].user.screen_name)")
                                print(favoriteListViewer[i].text)
                                print(favoriteListViewer[i].user.profile_image_url_https)
                                self.favoriteList.append(favoriteListViewer[i])
                                //self.twitterCellText.append(favoriteListViewer[i].text)
                            }
                            */
                            self.favoriteList = favoriteListViewer
                            
                            self.tableView.reloadData()
                        }
                        
                        

                        
                        self.view.addSubview(self.tableView)
                    
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
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    //セルに描画する内容（カスタムセル でレイアウトは決めてるので内容を投げる）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeLineCell") as! CustomTableViewCell
        
        let tweet = favoriteList[indexPath.row]
        cell.setCell(name: tweet.user.name, id: "@" + tweet.user.screen_name, content: tweet.text, iconImage: UIImage(url: tweet.user.profile_image_url_https))
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//URLを画像に変換
extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
