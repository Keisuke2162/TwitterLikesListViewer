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

import RealmSwift

class Login_APIrequest_Backup_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var provider: OAuthProvider?
    
    //タイムライン表示領域
    var tableView:UITableView!
    
    //メニューボタン表示
    let menuView = UIView()
        
    //relamのアイテムリスト
    var itemList: Results<TweetItem>!
    
    //表示用配列
    var showTweetItems: [TweetItem] = []
    
    //タイムライン取得用トークン、シークレットトークン
    var useToken: String = ""
    var useSecret: String = ""
    
    //認証済み判定
    var authFlag: Bool = false
    
    //tableViewのリフレッシュ
    let refresh = UIRefreshControl()
    
    //いいね欄保存用のRealmデータベース
    let realmLikesList = try! Realm()

    //twitterのキー保存用のクラス
    let twitterKeys = TwitterKeys()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Twitter
        provider = OAuthProvider(providerID: "twitter.com")
        
        
        //*****************UI設定*********************
        //tableView描画
        tableView = UITableView()
        tableView.frame = self.view.frame
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "timeLineCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(self.tableView)
        
        //メニューバー
        menuView.frame = CGRect(x: 0, y: view.frame.height * 0.8, width: view.frame.width, height: 70)
        menuView.backgroundColor = .red
        
        
        //更新ボタン
        let reloadButton = UIButton()
        reloadButton.frame = CGRect(x: view.frame.width - 70, y: 0, width: 70, height: 70)
        reloadButton.backgroundColor = .blue
        reloadButton.addTarget(self, action: #selector(TapReload), for: .touchUpInside)
        
        
        menuView.addSubview(reloadButton)
        view.addSubview(menuView)
        //********************************************
        
        
        refresh.addTarget(self, action: #selector(TapReload), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refresh
        
        //初回起動かどうかチェック
        let userDefault = FirstViewCheck()
        let getFirstView = userDefault.CheckFirstView()
        
        if getFirstView {
            //最初に起動した時
            print("初回起動")
            
            //Twitterログイン処理 & いいね欄取得
            SigninWithTwitter()
            
            //初回起動フラグをFalseへ
            userDefault.FalseFirstView()
            
        } else {
            //初回起動以外
            print("通常起動")
            
            //Realmからデータを取得
            
            itemList = realmLikesList.objects(TweetItem.self)

            
            showTweetItems = []
            //取得したデータを表示用配列に変換
            for i in 0 ..< itemList.count {
                let showItem = TweetItem()
                
                showItem.userName = itemList[i].userName
                showItem.userID = itemList[i].userID
                showItem.userIcon = itemList[i].userIcon
                showItem.content = itemList[i].content
                
                showTweetItems.append(showItem)
            }
            print("表示件数 = \(showTweetItems.count)")
            tableView.reloadData()
        }

    }
    
    @objc func TapReload() {
        //認証→取得→保存→一覧更新
        //SigninWithTwitter()
        
        let getKeys = twitterKeys.GetValue()
        
        useToken = getKeys.0
        useSecret = getKeys.1
        
        if useToken == "key" {
            SigninWithTwitter()
        } else {
            self.ShowTimeLine(accessToken: useToken, secret: useSecret)
        }
    }
    
    //Twitterへのログイン処理
    func SigninWithTwitter() {
        print("Sign in start")
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
                        
                        self.twitterKeys.SaveValue(token: token, secret: secret)
                        self.authFlag = true
                        
                        self.ShowTimeLine(accessToken: token, secret: secret)
                    }
                })
            }
        })
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
                            
                            //表示用配列の初期化
                            self.showTweetItems = []
                            
                            //タイムライン用Realmの初期化
                            try! self.realmLikesList.write {
                                self.realmLikesList.deleteAll()
                                print("remove Realm")
                            }
                            
                            //Realmへの保存→表示用配列への保存
                            for i in 0 ..< favoriteListViewer.count {
                                
                                //取得したデータをRealmに保存
                                let tweet: TweetItem = TweetItem()
                                
                                tweet.userIcon = favoriteListViewer[i].user.profile_image_url_https
                                tweet.userName = favoriteListViewer[i].user.name
                                tweet.userID = favoriteListViewer[i].user.screen_name
                                tweet.content = favoriteListViewer[i].text
                                //Realmへ書き込み
                                try! self.realmLikesList.write {
                                    self.realmLikesList.add(tweet)
                                }
                                
                                //
                                self.showTweetItems.append(tweet)
                            }
                            //Table Viewの更新
                            print("表示件数 = \(self.showTweetItems.count)")
                            self.refresh.endRefreshing()
                            self.tableView.reloadData()
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
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showTweetItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 125
    }
    
    
    //セルに描画する内容（カスタムセル でレイアウトは決めてるので内容を投げる）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeLineCell") as! CustomTableViewCell
        
        let tweet = showTweetItems[indexPath.row]
        cell.setCell(name: tweet.userName, id: tweet.userID, content: tweet.content, iconImage: UIImage(url: tweet.userIcon))
        
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
