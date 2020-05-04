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

class Login_APIrequest_Backup_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate {
    
    func MoveImageViewer(sender: [String], currentPage: Int) {
        let vc: ImageVewerViewController = ImageVewerViewController()
        print("選択画像→\(sender[0])")
        vc.imageNames = sender
        vc.currentPage = currentPage
        present(vc, animated: true, completion: nil)
    }
    
    
    var provider: OAuthProvider?
    
    //タイムライン表示領域
    var tableView:UITableView!
    
    //メニューボタン表示
    let menuView = UIView()
        
    //relamのアイテムリスト
    var itemList: Results<TweetItem>!
    
    //表示用配列
    var showTweetItems: [TweetItem] = []
    //画像表示用配列
    var showTweetImages: [[String]] = []
    
    //タイムライン取得用トークン、シークレットトークン
    var useToken: String = ""
    var useSecret: String = ""
    
    //認証済み判定
    var authFlag: Bool = false
    
    //tableViewのリフレッシュ
    let refresh = UIRefreshControl()
    
    //いいね欄保存用のRealmデータベース
    let realmLikesList = try! Realm()
    
    //カテゴライズしたツイートの保存
    var categoriseList: Results<CategoriseItem>!

    //twitterのキー保存用のクラス
    let twitterKeys = TwitterKeys()
    
    //カテゴリ名格納配列
    var category: [String] = []
    
    //カテゴリ配列取得用のクラス
    let categoryManage = ViewCategory()
    
    //振り分け用カテゴリ配列
    var setCategory: [String] = []
    
    //振り分け用ツイート配列
    var setTweet: [TweetItem] = []
    
    //カテゴリボタン用配列
    var categoryButtonArray: [CustomButton] = []
    
    //タイムラインの画像等表示用
    var imageFrame: [[CGRect]] = []
    
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
        menuView.frame = CGRect(x: 0, y: view.frame.height - 150, width: view.frame.width, height: 70)
        
        //メニューバーにカテゴリ一覧ボタンを表示
        //表示の土台となるスクロールView
        let categoryScroll = UIScrollView()
        categoryScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width - 70, height: 70)
        categoryScroll.backgroundColor = .black
        categoryScroll.layer.borderWidth = 1.0
        categoryScroll.layer.borderColor = UIColor.white.cgColor
        
        menuView.addSubview(categoryScroll)
        
        //カテゴリ一覧を取得
        category = categoryManage.GetValue()
        
        for i in 0 ..< category.count {
            let cateButton = CustomButton()
            cateButton.frame = CGRect(x: CGFloat(80 * i) + CGFloat(10 * i) + 10 , y: 10, width: 80, height: 50)
            cateButton.layer.cornerRadius = 10.0
            cateButton.layer.borderColor = UIColor.white.cgColor
            cateButton.layer.borderWidth = 1.0
            cateButton.setTitle(category[i], for: .normal)
            cateButton.categoryTitle = category[i]
            cateButton.tag = i
            cateButton.backgroundColor = .black
            cateButton.addTarget(self, action: #selector(TapCategoryButton), for: .touchUpInside)
            categoryButtonArray.append(cateButton)
            
            categoryScroll.addSubview(cateButton)
        }
        
        categoryScroll.contentSize = CGSize(width: CGFloat(80 * category.count) + CGFloat(10 * category.count) + 10, height: 70)
        
        //カテゴリ.ツイート決定ボタン
        let reloadButton = UIButton()
        reloadButton.frame = CGRect(x: view.frame.width - 70, y: 0, width: 70, height: 70)
        reloadButton.backgroundColor = .blue
        reloadButton.addTarget(self, action: #selector(TapDecisionButton), for: .touchUpInside)
        
        
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
            showTweetImages = []
            //取得したデータを表示用配列に変換
            for i in 0 ..< itemList.count {
                let showItem = TweetItem()
                var imageArray: [String] = []
                
                showItem.userName = itemList[i].userName
                showItem.userID = itemList[i].userID
                showItem.userIcon = itemList[i].userIcon
                showItem.content = itemList[i].content
                showItem.tweetID = itemList[i].tweetID
                
                for j in 0 ..< itemList[i].picImage.count {
                    showItem.picImage.append(itemList[i].picImage[j])
                    imageArray.append(showItem.picImage[j].image)
                }
                showTweetImages.append(imageArray)
                showTweetItems.append(showItem)
            }
            tableView.reloadData()
        }

    }
    
    @objc func TapDecisionButton() {
        
        if setCategory.count == 0 || setTweet.count == 0 {
            return
        }
        
        for i in 0 ..< categoryButtonArray.count {
            categoryButtonArray[i].layer.borderWidth = 1.0
            categoryButtonArray[i].buttonBool = false
        }
        
        //カテゴライズされたツイートを専用データベースへ登録
        for i in 0 ..< setTweet.count {
            for j in 0 ..< setCategory.count {
                let categoriseTweet: CategoriseItem = CategoriseItem()
                
                //移し替え
                categoriseTweet.userIcon = setTweet[i].userIcon
                categoriseTweet.userName = setTweet[i].userName
                categoriseTweet.userID = setTweet[i].userID
                categoriseTweet.content = setTweet[i].content
                categoriseTweet.tweetID = setTweet[i].tweetID
                
                //カテゴリ情報を格納
                categoriseTweet.category = setCategory[j]
                
                try! self.realmLikesList.write {
                    self.realmLikesList.add(categoriseTweet)
                }
            }

        }
        
        setCategory.removeAll()
        setTweet.removeAll()

    }
    
    @objc func TapCategoryButton (_ sender: CustomButton) {
        print(sender.buttonBool)
        
        if sender.buttonBool {
            sender.buttonBool = false
            sender.layer.borderWidth = 1.0
            
            for i in 0 ..< setCategory.count {
                print("OK")
                if sender.categoryTitle! == setCategory[i] {
                    setCategory.remove(at: i)
                    break
                }
            }
            
        } else {
            sender.buttonBool = true
            sender.layer.borderWidth = 3.0
            setCategory.append(category[sender.tag])
        }
    }
    
    @objc func TapReload() {
        //認証→取得→保存→一覧更新
        //SigninWithTwitter()
        
        //タイムライン用Realmの初期化
        try! self.realmLikesList.write {
            //self.realmLikesList.deleteAll()
            self.realmLikesList.delete(self.itemList)
            print("remove Realm")
        }
        
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

    //タイムライン取得処理
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
                            self.showTweetImages = []
                            
                            //カテゴリ選択情報のリセット
                            self.setCategory.removeAll()
                            self.setTweet.removeAll()

                            //Realmへの保存→表示用配列への保存
                            for i in 0 ..< favoriteListViewer.count {
                                //取得したデータをRealmに保存
                                let tweet: TweetItem = TweetItem()
                                
                                tweet.userIcon = favoriteListViewer[i].user.profile_image_url_https
                                tweet.userName = favoriteListViewer[i].user.name
                                tweet.userID = favoriteListViewer[i].user.screen_name
                                tweet.content = favoriteListViewer[i].text
                                tweet.tweetID = favoriteListViewer[i].id_str
                                
                                var tweetImages: [String] = []
                                //画像を保存
                                if let media = favoriteListViewer[i].extended_entities {
                                    
                                    for j in 0 ..< media.media.count {
                                        let image = Extended_Entities()
                                        image.image = media.media[j].media_url_https
                                        tweet.picImage.append(image)
                                        
                                        tweetImages.append(image.image)
                                        print("image保存 \(tweet.picImage[j].image)")
                                    }
                                }
                                
                                //Realmへ書き込み
                                try! self.realmLikesList.write {
                                    
                                    self.realmLikesList.add(tweet)
                                }
                                
                                
                                //
                                self.showTweetItems.append(tweet)
                                self.showTweetImages.append(tweetImages)
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
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 310
    }
    
    //セルタップ時の挙動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(showTweetItems[indexPath.row].tweetID)
        
        print("タップしたツイート情報")
        print("ユーザー名 -> \(showTweetItems[indexPath.row].userName)")
        print("ユーザーID -> \(showTweetItems[indexPath.row].userID)")
        print("画像枚数 -> \(showTweetImages[indexPath.row].count)")
        print("1枚目の画像 -> \(showTweetImages[indexPath.row])")
        
        //
        if showTweetItems[indexPath.row].judge {
            for i in 0 ..< setTweet.count {
                //ツイートのIDを比較
                if showTweetItems[indexPath.row].tweetID == setTweet[i].tweetID {
                    print("スタックから削除")
                    setTweet.remove(at: i)
                    break
                }
            }
            try! realmLikesList.write {
                showTweetItems[indexPath.row].judge = false
            }
            
        } else{
            setTweet.append(showTweetItems[indexPath.row])
            try! realmLikesList.write {
                showTweetItems[indexPath.row].judge = true
            }
        }
    }
    
    
    //セルに描画する内容（カスタムセル でレイアウトは決めてるので内容を投げる）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeLineCell") as! CustomTableViewCell
        
        let tweet = showTweetItems[indexPath.row]
        
        cell.setCell(name: tweet.userName, id: tweet.userID, content: tweet.content, iconImage: UIImage(url: tweet.userIcon),images: showTweetImages[indexPath.row])
        
        cell.delegate = self
        
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

class CustomButton: UIButton {
    var categoryTitle: String?
    var buttonBool: Bool = false
    var setNum: Int?
    
    //twitterURL用
    var twitterURL: String?
}
