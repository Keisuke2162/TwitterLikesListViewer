//
//  ImageVewerViewController.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/05/01.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit

class ImageVewerViewController: UIViewController, UIScrollViewDelegate {
    
    //var imageURLs: [String] = []
    
    var scrollView = UIScrollView()
    var pageControll = UIPageControl()
    
    var pageNum = 0
    var currentPage = 0
    
    var minZoom: CGFloat = 1.0
    var maxZoom: CGFloat = 1.0
    
    var imageNames: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        print("表示画像→\(imageNames[0])")
        
        /*
        let imageView = UIImageView()
        imageView.image = UIImage(url: imageNames[0])
        imageView.frame = view.bounds
        
        view.addSubview(imageView)
        */
        
        pageNum = imageNames.count
        
        setupPageControll()
        
        setupScrollView()
        print("ScrollView Width = \(scrollView.contentSize.width)")
        print("ScrollView Height = \(scrollView.contentSize.height)")
        print("image ---> \(imageNames[0])")
        
        for i in 0 ..< pageNum {
            print("i = \(i)")
            let subScrollView = MakeSubScroll(at: i)
            scrollView.addSubview(subScrollView)
            
            let imageView = MakeImageView(at: i)
            subScrollView.addSubview(imageView)
        }
        
        print("current --> \(currentPage)")
        print("contentOFFset -> \(scrollView.bounds.width * CGFloat(currentPage))")
        scrollView.contentOffset = CGPoint(x: scrollView.bounds.width * CGFloat(currentPage), y: 0)
        /*
        (0 ..< pageNum).forEach { page in
            let subScrollView = MakeSubScroll(at: page)
            
            let imageView = MakeImageView(at: page)
            subScrollView.addSubview(imageView)
            
            scrollView.addSubview(subScrollView)
        }
 */
        
        //setImages(imageArray: imageURLs)
        
        view.addSubview(scrollView)
        view.addSubview(pageControll)
        

        // Do any additional setup after loading the view.
    }
    
    /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupScrollView()
        
        
        
        (0 ..< pageNum).forEach { page in
            let subScrollView = MakeSubScroll(at: page)
            
            
            let imageView = MakeImageView(at: page)
            subScrollView.addSubview(imageView)
            
            scrollView.addSubview(subScrollView)
        }
        
        //setImages(imageArray: imageURLs)
        
        view.addSubview(scrollView)
        view.addSubview(pageControll)
    }
    */
    //表示する写真をもとにImageView作成
    func MakeImageView(at page: Int) -> UIImageView {
        let frame = scrollView.bounds
        print("frame X\(frame.origin.x)")
        print("frame Y\(frame.origin.y)")
        let imageView = UIImageView(frame: frame)
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = image(at: page)
        
        return imageView
    }
    
    func image(at page: Int) -> UIImage? {
        print("image -> \(imageNames[page])")
        return UIImage(url: imageNames[page])
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
