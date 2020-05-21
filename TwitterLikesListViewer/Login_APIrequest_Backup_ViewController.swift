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

class Login_APIrequest_Backup_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate, CategoryChoosed {
    
    
    func MoveImageViewer(sender: [MediaInfomation], currentPage: Int) {
        let vc: ImageVewerViewController = ImageVewerViewController()
        vc.imageInformation = sender
        vc.currentPage = currentPage
        vc.modalPresentationStyle = .fullScreen
        
        //show(vc, sender: nil)
        present(vc, animated: true, completion: nil)
    }
    
    //Cellのチェックボックスがタップされた場合の処理
    func TweetChecked(row: Int, judge: Bool) {
        
        if showTweetItems[row].judge {
            for i in 0 ..< setTweet.count {
                //ツイートのIDを比較
                if showTweetItems[row].tweetID == setTweet[i].tweetID {
                    print("スタックから削除")
                    setTweet.remove(at: i)
                    break
                }
            }
            try! realmLikesList.write {
                showTweetItems[row].judge = false
            }
            
        } else{
            print("スタックに登録")
            //カテゴリ分け用の配列にチェックしたツイートデータを格納
            setTweet.append(showTweetItems[row])
            
            try! realmLikesList.write {
                showTweetItems[row].judge = true
            }
        }
    }
    
    //色一覧
    var colorArray: [UIColor] = []
    
    
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
    //var showTweetImages: [[String]] = []
    //新画像表示用配列
    var showTweetMedias: [[MediaInfomation]] = []
    
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
    //var setCategory: [String] = []
    var categoryArray: [String] = []
    
    //振り分け用ツイート配列
    var setTweet: [TweetItem] = []
    
    //カテゴリボタン用配列
    var categoryButtonArray: [CustomButton] = []
    
    //タイムラインの画像等表示用
    var imageFrame: [[CGRect]] = []
    
    var categoryViewOpenCheck: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Twitter
        provider = OAuthProvider(providerID: "twitter.com")
        
        //*****************UI設定*********************************************************
        //tableView描画
        tableView = UITableView()
        tableView.frame = self.view.frame
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "timeLineCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(self.tableView)
        
        //リスト表示ボタン
        let listButton = UIButton()
        listButton.frame = CGRect(x: view.frame.width - 70, y: view.frame.height - 130, width: 50, height: 50)
        listButton.backgroundColor = UIColor.dynamicColor(light: .black, dark: .white)
        listButton.layer.cornerRadius = 25
        listButton.addTarget(self, action: #selector(MoveCategoryListView), for: .touchUpInside)
        
        view.addSubview(listButton)
        
        //決定ボタン
        let decisionButton = UIButton()
        decisionButton.frame = CGRect(x: view.frame.width - 140, y: view.frame.height - 130, width: 50, height: 50)
        decisionButton.backgroundColor = UIColor.dynamicColor(light: .black, dark: .white)
        decisionButton.layer.cornerRadius = 25
        decisionButton.addTarget(self, action: #selector(TapDecisionButton), for: .touchUpInside)
        
        view.addSubview(decisionButton)
        //******************************************************************************
        
        
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
            showTweetMedias = []
            
            //取得したデータを表示用配列に変換
            for i in 0 ..< itemList.count {
                let showItem = TweetItem()
                //var imageArray: [String] = []
                var mediaArray: [MediaInfomation] = []
                var media = MediaInfomation()
                
                showItem.userName = itemList[i].userName
                showItem.userID = itemList[i].userID
                showItem.userIcon = itemList[i].userIcon
                showItem.content = itemList[i].content
                showItem.tweetID = itemList[i].tweetID
                
                
                for j in 0 ..< itemList[i].picImage.count {
                    showItem.picImage.append(itemList[i].picImage[j])
                    
                    media.type = itemList[i].picImage[j].type
                    
                    media.imageURL = itemList[i].picImage[j].image
                    mediaArray.append(media)
                    
                }
                showTweetMedias.append(mediaArray)
                showTweetItems.append(showItem)
            }
            tableView.reloadData()
        }

    }
    
    //カテゴリ一覧画面への遷移
    @objc func MoveCategoryListView() {
        let vc = CategoryChoiseViewController()
        vc.tabColor = colorArray
        vc.delegate = self
        vc.checkCategory = categoryArray
        
        print(categoryArray)
        
        present(vc, animated: true, completion: nil)
    }
    
    //カテゴライズ決定ボタン押下時
    @objc func TapDecisionButton() {
        
        if categoryArray.count == 0 || setTweet.count == 0 {
            return
        }
        
        for i in 0 ..< categoryButtonArray.count {
            categoryButtonArray[i].layer.borderWidth = 1.0
            categoryButtonArray[i].buttonBool = false
        }
        
        //カテゴライズされたツイートを専用データベースへ登録
        for i in 0 ..< setTweet.count {
            for j in 0 ..< categoryArray.count {
                let categoriseTweet: CategoriseItem = CategoriseItem()
                
                //移し替え
                categoriseTweet.userIcon = setTweet[i].userIcon
                categoriseTweet.userName = setTweet[i].userName
                categoriseTweet.userID = setTweet[i].userID
                categoriseTweet.content = setTweet[i].content
                categoriseTweet.tweetID = setTweet[i].tweetID
                categoriseTweet.picImage = setTweet[i].picImage
                
                //カテゴリ情報を格納
                categoriseTweet.category = categoryArray[j]
                
                try! self.realmLikesList.write {
                    self.realmLikesList.add(categoriseTweet)
                }
            }
            setTweet[i].judge = false
        }
        
        //setCategory.removeAll()
        setTweet.removeAll()

    }
    
    
    //リロード処理
    @objc func TapReload() {
        
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
                        
                        //
                        DispatchQueue.main.async {
                            //いいね欄のツイート情報を取得
                            guard let favoriteListViewer = try? JSONDecoder().decode([Favorite].self, from: favResponse.data) else {
                                print("GetFavorite_Decode Error")
                                return
                            }
                            print("fav_success")
                            
                            //表示用配列の初期化
                            self.showTweetItems = []
                            self.showTweetMedias = []
                            
                            //カテゴリ選択情報のリセット
                            //self.setCategory.removeAll()
                            self.setTweet.removeAll()

                            //Realmへの保存 & 表示用配列への保存
                            for i in 0 ..< favoriteListViewer.count {
                                //取得したデータをRealmに保存
                                let tweet: TweetItem = TweetItem()
                                
                                tweet.userIcon = favoriteListViewer[i].user.profile_image_url_https
                                tweet.userName = favoriteListViewer[i].user.name
                                tweet.userID = favoriteListViewer[i].user.screen_name
                                tweet.content = favoriteListViewer[i].text
                                tweet.tweetID = favoriteListViewer[i].id_str
                                
                                
                                //Media関連用の配列（画像、GIF、動画）
                                var tweetMedia = MediaInfomation()
                                var mediaArray: [MediaInfomation] = []
                                
                                //メディアデータがある場合（画像、GIF、動画）
                                if let media = favoriteListViewer[i].extended_entities {
                                    //メディア数(1~4 / 動画、GIFの場合は 1)
                                    for j in 0 ..< media.media.count {
                                        let image = Extended_Entities()
                                        
                                        image.type = media.media[j].type
                                        
                                        //動画関連処理
                                        if media.media[j].type == "animated_gif" || media.media[j].type == "video" {
                                            
                                            if let video = media.media[j].video_info {
                                                //Realm用
                                                image.image = video.variants[0].url
                                                
                                                //表示用
                                                tweetMedia.imageURL = video.variants[0].url
                                                
                                            } else {
                                                //GIFかVideoのはずなのに動画URLがない
                                                print("Movide Data Error")
                                                
                                                //Sample URLを格納？
                                                image.image = ""
                                                tweetMedia.imageURL = ""
                                            }
                                        } else {
                                            //画像関連処理
                                            //Realm用
                                            image.image = media.media[j].media_url_https
                                            
                                            //表示用
                                            tweetMedia.imageURL = image.image
                                        }
                                                            
                                        tweetMedia.type = image.type
                                        
                                        tweet.picImage.append(image)
                                        
                                        
                                        mediaArray.append(tweetMedia)
                                    }
                                }
                                
                                //Realmへ書き込み
                                try! self.realmLikesList.write {
                                    
                                    self.realmLikesList.add(tweet)
                                }
                                
                                
                                //
                                self.showTweetItems.append(tweet)
                                self.showTweetMedias.append(mediaArray)
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
    
    var cellHeight: CGFloat = 0
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showTweetItems.count
    }
    
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 175
    }
    
    
    //セルタップ時の挙動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(UITableView.automaticDimension)
        
        let vc = WebTweetViewController()
        let url = "https://twitter.com/" + showTweetItems[indexPath.row].userID + "/status/" + showTweetItems[indexPath.row].tweetID
        vc.modalPresentationStyle = .fullScreen
        vc.url = url
        
        //画面遷移を右へ
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .push
        transition.subtype = .fromRight
        view.window?.layer.add(transition, forKey: kCATransition)
        
        //show(vc, sender: nil)
        present(vc, animated: false, completion: nil)
    }
    
    
    //セルに描画する内容（カスタムセル でレイアウトは決めてるので内容を投げる）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeLineCell") as! CustomTableViewCell
        
        let tweet = showTweetItems[indexPath.row]
        
        cell.setCell(name: tweet.userName, id: tweet.userID, content: tweet.content, iconImage: UIImage(url: tweet.userIcon),images: showTweetMedias[indexPath.row], judge: tweet.judge)
        cell.row = indexPath.row
        
        
        cell.delegate = self
        
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}




