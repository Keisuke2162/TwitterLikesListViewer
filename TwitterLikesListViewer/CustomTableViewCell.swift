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
    
    /*
    var firstImage = UIImageView()
    var secondImage = UIImageView()
    var thirdImage = UIImageView()
    var fourthImage = UIImageView()
    */
    
    var firstImage = UIButton()
    var secondImage = UIButton()
    var thirdImage = UIButton()
    var fourthImage = UIButton()
    
    var imageURLs: [String] = []
    
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
        
        contentView.addSubview(firstImage)
        contentView.addSubview(secondImage)
        contentView.addSubview(thirdImage)
        contentView.addSubview(fourthImage)
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
        firstImage.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
        firstImage.tag = 0
        firstImage.layer.cornerRadius = 10.0
        
        //
        secondImage.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
        secondImage.tag = 1
        
        //
        thirdImage.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
        thirdImage.tag = 2
        
        //
        fourthImage.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
        fourthImage.tag = 3
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
        
        switch images.count {
        case 0:
            
            firstImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            secondImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            thirdImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            fourthImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            break
        case 1:
            
            firstImage.frame = CGRect(x: 100, y: 130, width: self.frame.width - 120, height: 180)
            secondImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            thirdImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            fourthImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            firstImage.setImage(UIImage(url: images[0]), for: .normal)
            

            
            break
        case 2:
            
            firstImage.frame = CGRect(x: 105, y: 130, width: (self.frame.width - 110) / 2 - 2.5, height: 180)
            secondImage.frame = CGRect(x: 100 + ((self.frame.width - 110) / 2) + 2.5, y: 130, width: (self.frame.width - 110) / 2 - 2.5, height: 180)
            thirdImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            fourthImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            firstImage.setImage(UIImage(url: images[0]), for: .normal)
            secondImage.setImage(UIImage(url: images[1]), for: .normal)
            
            break
        case 3:
            
            firstImage.frame = CGRect(x: 100, y: 130, width: (self.frame.width - 100) / 2, height: 180)
            secondImage.frame = CGRect(x: 100 + ((self.frame.width - 100) / 2), y: 130, width: (self.frame.width - 100) / 2, height: 90)
            thirdImage.frame = CGRect(x: 100 + ((self.frame.width - 100) / 2), y: 280, width: (self.frame.width - 100) / 2, height: 90)
            fourthImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            firstImage.setImage(UIImage(url: images[0]), for: .normal)
            secondImage.setImage(UIImage(url: images[1]), for: .normal)
            thirdImage.setImage(UIImage(url: images[2]), for: .normal)
            
            break
        case 4:
            
            firstImage.frame = CGRect(x: 100, y: 130, width: (self.frame.width - 100) / 2, height: 90)
            secondImage.frame = CGRect(x: 100 + ((self.frame.width - 100) / 2), y: 130, width: (self.frame.width - 100) / 2, height: 90)
            thirdImage.frame = CGRect(x: 100, y: 280, width: (self.frame.width - 100) / 2, height: 90)
            fourthImage.frame = CGRect(x: 100 + ((self.frame.width - 100) / 2), y: 280, width: (self.frame.width - 100) / 2, height: 90)
            
            firstImage.setImage(UIImage(url: images[0]), for: .normal)
            secondImage.setImage(UIImage(url: images[1]), for: .normal)
            thirdImage.setImage(UIImage(url: images[2]), for: .normal)
            fourthImage.setImage(UIImage(url: images[3]), for: .normal)
            
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
        let imgRef = image.cgImage?.cropping(to: trimmingArea)
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
}



