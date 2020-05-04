//
//  CustomTableViewCell.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/26.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit

protocol CustomCellDelegate {
    func MoveImageViewer(sender: [String], currentPage: Int)
}

class CustomTableViewCell: UITableViewCell {
    
    var delegate: CustomCellDelegate?
    
    var iconImageView = UIImageView()
    var userName = UILabel()
    var userID = UILabel()
    var contentLabel = UILabel()
    var contentPic = UIImageView()
    
    let imageViewer = UIView()
    
    var imageURLs: [String] = []
    
    var twitterButton = CustomButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(userName)
        contentView.addSubview(userID)
        contentView.addSubview(contentPic)
        
        contentView.addSubview(imageViewer)
        
        contentView.addSubview(twitterButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //ユーザーアイコン
        iconImageView.frame = CGRect(x: 20, y: 20, width: 60, height: 60)
        iconImageView.layer.cornerRadius = 30
        iconImageView.clipsToBounds = true
        
        //ユーザー名
        userName.frame = CGRect(x: 100, y: 0, width: self.frame.width - 100, height: 30)
        
        //ユーザーID
        userID.frame = CGRect(x: 100, y: 30, width: self.frame.width - 100, height: 20)
        userID.textColor = .gray
        
        //ツイート内容
        contentLabel.frame = CGRect(x: 100, y: 50, width: self.frame.width - 100, height: 75)
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        
        //
        imageViewer.layer.cornerRadius = 20.0
        imageViewer.frame = CGRect(x: 100, y: 130, width: self.frame.width - 120, height: 180)
        
        //twitterで開くボタン
        twitterButton.frame = CGRect(x: 25, y: 90, width: 50, height: 50)
        twitterButton.backgroundColor = .blue
        twitterButton.layer.cornerRadius = 25
        
    }
    
    override func prepareForReuse() {
        
    }
    
    
    func setCell(name: String, id: String, content: String?, iconImage: UIImage, images: [String]) {
        
        iconImageView.image = iconImage
        userName.text = name
        userID.text = id
        imageURLs = images
        
        if let content = content {
            contentLabel.text = content
        } else {
            print("error")
            contentLabel.text = ""
        }
        
        //imageViewer上の画像を削除
        let subView = imageViewer.subviews
        for sub in subView {
            sub.removeFromSuperview()
        }
        
        switch images.count {
        case 0:
            imageViewer.isHidden = true
            
            break
        case 1:
            imageViewer.frame = CGRect(x: 100, y: 130, width: self.frame.width - 120, height: 180)
            
            let image = UIButton(frame: CGRect(x: 0, y: 0, width: imageViewer.frame.width, height: imageViewer.frame.height))
            image.backgroundColor = .red
            image.tag = 0
            
            //let setImage = trimmingImage(UIImage(url: imageURLs[0]), trimmingArea: image.frame)
            let setImage = resizeUIImageByWidth(image: UIImage(url: imageURLs[0]), width: Double(image.frame.width))
            let trimImage = trimmingImage(setImage, trimmingArea: image.frame)
            image.setImage(trimImage, for: .normal)
            image.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
            
            imageViewer.addSubview(image)
            
            
            break
        case 2:
            imageViewer.frame = CGRect(x: 100, y: 130, width: self.frame.width - 120, height: 180)
            
            let image_one = UIButton(frame: CGRect(x: 0, y: 0, width: imageViewer.frame.width / 2 - 5, height: imageViewer.frame.height))
            let image_two = UIButton(frame: CGRect(x: imageViewer.frame.width / 2 + 5, y: 0, width: imageViewer.frame.width / 2 - 5, height: imageViewer.frame.height))
            
            let imageArray: [UIButton] = [image_one, image_two]
            
            for i in 0 ..< imageArray.count {
                let setImage = resizeUIImageByWidth(image: UIImage(url: imageURLs[i]), width: Double(imageArray[i].frame.width))
                let trimImage = trimmingImage(setImage, trimmingArea: imageArray[i].frame)
                
                imageArray[i].setImage(trimImage, for: .normal)
            }
            
            image_one.tag = 0
            image_two.tag = 1
            
            image_one.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
            image_two.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
            
            imageViewer.addSubview(image_one)
            imageViewer.addSubview(image_two)
            
            break
        case 3:
            imageViewer.frame = CGRect(x: 100, y: 130, width: self.frame.width - 120, height: 180)
            
            let image_one = UIButton(frame: CGRect(x: 0, y: 0, width: imageViewer.frame.width / 2 - 5, height: imageViewer.frame.height))
            let image_two = UIButton(frame: CGRect(x: imageViewer.frame.width / 2 + 5, y: 0, width: imageViewer.frame.width / 2 - 5, height: imageViewer.frame.height / 2 - 5))
            let image_thr = UIButton(frame: CGRect(x: imageViewer.frame.width / 2 + 5, y: imageViewer.frame.height / 2 + 5, width: imageViewer.frame.width / 2 - 5, height: imageViewer.frame.height / 2 - 5))
            
            let imageArray: [UIButton] = [image_one, image_two, image_thr]
            
            for i in 0 ..< imageArray.count {
                let setImage = resizeUIImageByWidth(image: UIImage(url: imageURLs[i]), width: Double(imageArray[i].frame.width))
                let trimImage = trimmingImage(setImage, trimmingArea: imageArray[i].frame)
                
                imageArray[i].setImage(trimImage, for: .normal)
            }
            
            image_one.tag = 0
            image_two.tag = 1
            image_thr.tag = 2
            
            image_one.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
            image_two.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
            image_thr.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
            
            imageViewer.addSubview(image_one)
            imageViewer.addSubview(image_two)
            imageViewer.addSubview(image_thr)
            
            break
        case 4:
            imageViewer.frame = CGRect(x: 100, y: 130, width: self.frame.width - 120, height: 180)
            
            let image_one = UIButton(frame: CGRect(x: 0, y: 0, width: imageViewer.frame.width / 2 - 5, height: imageViewer.frame.height / 2 - 5))
            let image_two = UIButton(frame: CGRect(x: imageViewer.frame.width / 2 + 5, y: 0, width: imageViewer.frame.width / 2 - 5, height: imageViewer.frame.height / 2 - 5))
            let image_thr = UIButton(frame: CGRect(x: 0, y: imageViewer.frame.height / 2 + 5, width: imageViewer.frame.width / 2 - 5, height: imageViewer.frame.height / 2 - 5))
            let image_fou = UIButton(frame: CGRect(x: imageViewer.frame.width / 2 + 5, y: imageViewer.frame.height / 2 + 5, width: imageViewer.frame.width / 2 - 5, height: imageViewer.frame.height / 2 - 5))
            
            let imageArray: [UIButton] = [image_one, image_two, image_thr, image_fou]
            
            for i in 0 ..< imageArray.count {
                let setImage = resizeUIImageByWidth(image: UIImage(url: imageURLs[i]), width: Double(imageArray[i].frame.width))
                let trimImage = trimmingImage(setImage, trimmingArea: imageArray[i].frame)
                
                imageArray[i].setImage(trimImage, for: .normal)
            }
            
            image_one.tag = 0
            image_two.tag = 1
            image_thr.tag = 2
            image_fou.tag = 3
            
            image_one.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
            image_two.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
            image_thr.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
            image_fou.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
            
            imageViewer.addSubview(image_one)
            imageViewer.addSubview(image_two)
            imageViewer.addSubview(image_thr)
            imageViewer.addSubview(image_fou)
            
            break
        default:
            print("Error")
        }
    }
    
    @objc func TapedImage(_ sender: UIButton) {
        print(sender.tag)
        delegate?.MoveImageViewer(sender: imageURLs, currentPage: sender.tag)
        
    }
    
    //画像をトリミングする
    func trimmingImage(_ image: UIImage, trimmingArea: CGRect) -> UIImage {
        //let trimming = CGRect(x: image.size.width / 2 - (trimmingArea.width / 2), y: image.size.height / 2 - (trimmingArea.height / 2), width: trimmingArea.width, height: trimmingArea.height)
        let trimming = CGRect(x: 0, y: image.size.height / 2 - (trimmingArea.height / 2), width: image.size.width, height: trimmingArea.height)
        let imgRef = image.cgImage?.cropping(to: trimming)
        let trimImage = UIImage(cgImage: imgRef!, scale: image.scale, orientation: image.imageOrientation)
        return trimImage
    }
    /*
    func imageTrimming(_ URLs: [String]) -> UIImage {
        
        for i in 0 ..< URLs.count {
            let imageRef = UIImage(url: URLs[i]).cgImage?.cropping(to: imageRects[i])
        }
    }
    */
    
    /**
     * 横幅を指定してUIImageをリサイズする
     * @params image: 対象の画像
     * @params width: 基準となる横幅
     * @return 横幅をwidthに、縦幅はアスペクト比を保持したサイズにリサイズしたUIImage
    */
    func resizeUIImageByWidth(image: UIImage, width: Double) -> UIImage {
      // オリジナル画像のサイズから、アスペクト比を計算
      let aspectRate = image.size.height / image.size.width
      // リサイズ後のWidthをアスペクト比を元に、リサイズ後のサイズを取得
      let resizedSize = CGSize(width: width, height: width * Double(aspectRate))
      // リサイズ後のUIImageを生成して返却
      UIGraphicsBeginImageContext(resizedSize)
      image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
      let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return resizedImage!
    }
}



