//
//  ImageVewerViewController.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/05/01.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit
import AVFoundation

class ImageVewerViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView = UIScrollView()
    var pageControll = UIPageControl()
    
    var pageNum = 0
    var currentPage = 0
    
    var minZoom: CGFloat = 1.0
    var maxZoom: CGFloat = 1.0
    
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    
    var imageInformation: [MediaInfomation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        width = view.frame.width
        height = view.frame.height
        
        //動画は1件のみしか投稿できないため配列の先頭のみ比較する
        if imageInformation[0].type == "video" || imageInformation[0].type == "animated_gif"{
            
            print("Video です")
            
            let url = URL(string: imageInformation[0].imageURL)
            //let url = URL(string: testURL)
            let player = AVPlayer(url: url!)
            
            let playerLayer = AVPlayerLayer(player: player)
            //playerLayer.frame = self.view.bounds
            playerLayer.frame = CGRect(x: 0, y: height * 0.1, width: width, height: height * 0.8)
            self.view.layer.addSublayer(playerLayer)
            
            player.play()
            
        } else {
            
            //表示タイプが動画以外の場合
            pageNum = imageInformation.count
            
            setupPageControll()
            
            setupScrollView()
            
            for i in 0 ..< pageNum {
                
                //通常画像の場合
                print("Imageです")
                let subScrollView = MakeSubScroll(at: i)
                scrollView.addSubview(subScrollView)
                
                let imageView = MakeImageView(at: i)
                subScrollView.addSubview(imageView)
                
                /*
                //GIFの場合
                if imageInformation[i].type == "animated_gif" {
                    print("GIFです")
                    let subScrollView = MakeSubScroll(at: i)
                    scrollView.addSubview(subScrollView)
                    
                    //let imageView = MakeImageView(at: i)
                    //subScrollView.addSubview(imageView)
                    
                    let gifView = MakeGifMovie(at: i)
                    subScrollView.layer.addSublayer(gifView)
                    
                } else {
                    //通常画像の場合
                    print("Imageです")
                    let subScrollView = MakeSubScroll(at: i)
                    scrollView.addSubview(subScrollView)
                    
                    let imageView = MakeImageView(at: i)
                    subScrollView.addSubview(imageView)
                }
                */
            }
            
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.width * CGFloat(currentPage), y: 0)
            
            view.addSubview(scrollView)
            view.addSubview(pageControll)
            
        }
        
        
        let returnButton = UIButton()
        returnButton.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        returnButton.backgroundColor = .red
        returnButton.addTarget(self, action: #selector(ReturnView), for: .touchUpInside)
        view.addSubview(returnButton)

        // Do any additional setup after loading the view.
    }
    
    let playerLayer = AVPlayerLayer()
    
    func MakeMovie(url: String, frame: CGRect) {
        print("Video作成します")
        
        let url = URL(string: imageInformation[0].imageURL)
        let player = AVPlayer(url: url!)
        
        //let playerLayer = AVPlayerLayer(player: player)
        //playerLayer.frame = self.view.bounds
        playerLayer.player = player
        playerLayer.frame = CGRect(x: 0, y: height * 0.1, width: width, height: height * 0.8)
        self.view.layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        player.play()
    }
    
    
    //GIF動画再生終了時
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        // 動画を最初に巻き戻す
        self.playerLayer.player?.currentItem?.seek(to: CMTime.zero, completionHandler: nil)
    }
    
    //画面を戻る
    @objc func ReturnView() {
        dismiss(animated: true, completion: nil)
    }
    
    func MakeGifMovie(at page: Int) -> AVPlayerLayer {
        let frame = scrollView.bounds
        
        let url = URL(string: imageInformation[page].imageURL)
        let player = AVPlayer(url: url!)
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = frame
        player.play()
        
        return playerLayer
    }
    //表示する写真をもとにImageView作成
    func MakeImageView(at page: Int) -> UIImageView {
        let frame = scrollView.bounds
        let imageView = UIImageView(frame: frame)
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = image(at: page)
        
        return imageView
    }
    
    func image(at page: Int) -> UIImage? {
        return UIImage(url: imageInformation[page].imageURL)
    }
    
    //サブスクロールViewを作成する
    func MakeSubScroll(at page: Int) -> UIScrollView {
        //subscrollVIewのフレームを決定
        let frame = CalcSubScrollFrame(at: page)
        //frameをもとにUIScrollViewを作成
        let subScrollView = UIScrollView(frame: frame)
        
        //色々設定
        subScrollView.delegate = self
        subScrollView.showsVerticalScrollIndicator = false
        subScrollView.showsHorizontalScrollIndicator = false
        subScrollView.minimumZoomScale = minZoom
        subScrollView.maximumZoomScale = maxZoom
        
        //subScrollViewがタップされた時のアクションを登録
        
        
        return subScrollView
    }
    
    //サブスクロールのframe値を計算（）
    func CalcSubScrollFrame(at page: Int) -> CGRect {
        var frame = scrollView.bounds
        frame.origin.x = CalcXposition(at: page)
        
        return frame
    }
    
    //mainScrollViewを設置んぐ
    func setupScrollView() {
        scrollView.frame = view.bounds
        scrollView.backgroundColor = .blue
        scrollView.delegate = self
        scrollView.minimumZoomScale = minZoom
        scrollView.maximumZoomScale = maxZoom
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.contentSize = CGSize(width: CalcXposition(at: pageNum), height: scrollView.bounds.height)
        
    }
    
    func setupPageControll() {
        pageControll.frame = CGRect(x: 0, y: view.frame.height * 0.8, width: view.frame.width, height: view.frame.height * 0.1)
        //ページ数
        pageControll.numberOfPages = pageNum
        //現在のページ数
        pageControll.currentPage = currentPage
        //値が変化したときの動作
        pageControll.addTarget(self, action: #selector(ChangePageControll), for: .valueChanged)
        
        view.addSubview(pageControll)
    }
    
    @objc func ChangePageControll() {
        //現在のページを更新
        currentPage = pageControll.currentPage
        //更新後のページのX座標を計算
        let xPos = CalcXposition(at: currentPage)
        //スクロール後の
        scrollView.setContentOffset(CGPoint(x: xPos, y: 0), animated: true)
    }
    
    func CalcXposition(at position: Int) -> CGFloat {
        return scrollView.bounds.width * CGFloat(position)
    }

    
    func setImages(imageArray: [String]) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
