//
//  CustomTableViewCell.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/26.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit

protocol CustomCellDelegate {
    func MoveImageViewer(sender: [MediaInfomation], currentPage: Int)
    func TweetChecked(row: Int, judge: Bool)
}

class CustomTableViewCell: UITableViewCell {
    
    var delegate: CustomCellDelegate?
    
    var iconImageView = UIImageView()
    var userName = UILabel()
    var userID = UILabel()
    var contentLabel = UILabel()
    var contentPic = UIImageView()
    
    //let imageViewer = UIView()
    
    let firstThingButton = CustomButton()
    let secondThingButton = CustomButton()
    let thirdThingButton = CustomButton()
    let fourthThingButton = CustomButton()
    
    //let videoButton = CustomButton()
    
    var thingButtons: [CustomButton] = []
    
    var imageURLs: [MediaInfomation] = []
    
    //var twitterButton = CustomButton()
    
    var checkButton = UIButton()
    
    var checkBool: Bool = false
    
    var row: Int = 0
    
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
        
        //contentView.addSubview(imageViewer)
        
        contentView.addSubview(firstThingButton)
        contentView.addSubview(secondThingButton)
        contentView.addSubview(thirdThingButton)
        contentView.addSubview(fourthThingButton)
        
        //contentView.addSubview(twitterButton)
        contentView.addSubview(checkButton)
        //contentView.addSubview(videoButton)
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
        userName.frame = CGRect(x: 100, y: 0, width: self.frame.width - 170, height: 30)
        
        //ユーザーID
        userID.frame = CGRect(x: 100, y: 30, width: self.frame.width - 170, height: 20)
        userID.textColor = .gray
        
        //ツイート内容
        contentLabel.frame = CGRect(x: 100, y: 50, width: self.frame.width - 125, height: 75)
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        contentLabel.sizeToFit()
        
        //
        let buttonFrameY = contentLabel.frame.origin.y + contentLabel.frame.height + 10
        
        firstThingButton.frame = CGRect(x: 100, y: buttonFrameY, width: 55, height: 55)
        firstThingButton.tag = 0
        //firstThingButton.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
        //firstThingButton.backgroundColor = UIColor(colorCode: "1DA1F2")
        firstThingButton.layer.cornerRadius = 27.5
        //firstThingButton.setImage(UIImage(named: "camera"), for: .normal)
        firstThingButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        //firstThingButton.isHidden = true
        
        secondThingButton.frame = CGRect(x: 110 + 55, y: buttonFrameY, width: 55, height: 55)
        secondThingButton.tag = 1
        //secondThingButton.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
        //secondThingButton.backgroundColor = UIColor(colorCode: "1DA1F2")
        secondThingButton.layer.cornerRadius = 27.5
        //secondThingButton.setImage(UIImage(named: "camera"), for: .normal)
        secondThingButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        //secondThingButton.isHidden = true
        
        thirdThingButton.frame = CGRect(x: 120 + 110, y: buttonFrameY, width: 55, height: 55)
        thirdThingButton.tag = 2
        //thirdThingButton.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
        //thirdThingButton.backgroundColor = UIColor(colorCode: "1DA1F2")
        thirdThingButton.layer.cornerRadius = 27.5
        //thirdThingButton.setImage(UIImage(named: "camera"), for: .normal)
        thirdThingButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        //thirdThingButton.isHidden = true
        
        fourthThingButton.frame = CGRect(x: 130 + 165, y: buttonFrameY, width: 55, height: 55)
        fourthThingButton.tag = 3
        //fourthThingButton.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
        //fourthThingButton.backgroundColor = UIColor(colorCode: "1DA1F2")
        fourthThingButton.layer.cornerRadius = 27.5
        //fourthThingButton.setImage(UIImage(named: "camera"), for: .normal)
        fourthThingButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        //fourthThingButton.isHidden = true
        
        /*
        //twitterで開くボタン
        twitterButton.frame = CGRect(x: 25, y: 90, width: 50, height: 50)
        //twitterButton.backgroundColor = .blue
        twitterButton.layer.cornerRadius = 25
        twitterButton.setImage(UIImage(named: "twitter"), for: .normal)
        twitterButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        */
        
        //チェックボックス
        checkButton.frame = CGRect(x: self.frame.width - 50, y: 10, width: 40, height: 40)
        checkButton.backgroundColor = UIColor(colorCode: "1DA1F2")
        checkButton.layer.cornerRadius = 20
        //checkButton.setImage(UIImage(named: "check"), for: .normal)
        checkButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        checkButton.addTarget(self, action: #selector(TapedCheckButton), for: .touchUpInside)
        
        /*
        //動画ボタン
        videoButton.frame = CGRect(x: 100, y: buttonFrameY, width: self.frame.width / 7.5, height: self.frame.width / 7.5)
        videoButton.tag = 0
        videoButton.addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
        videoButton.backgroundColor = UIColor(colorCode: "FF0000")
        videoButton.layer.cornerRadius = self.frame.width / 15
        videoButton.setImage(UIImage(named: "video"), for: .normal)
        videoButton.imageEdgeInsets = UIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        //videoButton.isHidden = true
        */
    }
    
    override func prepareForReuse() {
        firstThingButton.isHidden = true
        secondThingButton.isHidden = true
        thirdThingButton.isHidden = true
        fourthThingButton.isHidden = true
        
        //videoButton.isHidden = true
    }
    
    
    func setCell(name: String, id: String, content: String?, iconImage: UIImage, images: [MediaInfomation], judge: Bool) {
        
        iconImageView.image = iconImage
        userName.text = name
        userID.text = id
        imageURLs = images
        checkBool = judge
        
        if let content = content {
            contentLabel.text = content
        } else {
            print("error")
            contentLabel.text = ""
        }
        
        if checkBool {
            checkButton.setImage(UIImage(named: "check"), for: .normal)
        } else {
            checkButton.setImage(nil, for: .normal)
        }
        
        
        thingButtons = [firstThingButton, secondThingButton, thirdThingButton, fourthThingButton]
        
        for i in 0 ..< imageURLs.count {
            if imageURLs[i].type == "video" {
                //videoButton.isHidden = false
                thingButtons[i].isHidden = false
                thingButtons[i].setImage(UIImage(named: "video"), for: .normal)
                thingButtons[i].backgroundColor = UIColor(colorCode: "FF0000")
                thingButtons[i].addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
                
                
            } else if imageURLs[i].type == "animated_gif" {
                thingButtons[i].isHidden = false
                thingButtons[i].setImage(UIImage(named: "gif"), for: .normal)
                thingButtons[i].backgroundColor = UIColor(colorCode: "1DA1F2")
                thingButtons[i].addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
                
                //print(imageURLs[i].imageURL)
                
            } else {
                thingButtons[i].isHidden = false
                thingButtons[i].setImage(UIImage(named: "camera"), for: .normal)
                thingButtons[i].backgroundColor = UIColor(colorCode: "1DA1F2")
                thingButtons[i].addTarget(self, action: #selector(TapedImage), for: .touchUpInside)
                
            }
            
        }
        
    }
    
    
    @objc func TapedImage(_ sender: UIButton) {
        //print(sender.tag)
        delegate?.MoveImageViewer(sender: imageURLs, currentPage: sender.tag)
        
    }
    
    //チェックボタンを押した時
    @objc func TapedCheckButton() {
        delegate?.TweetChecked(row: row, judge: false)
        if checkBool {
            checkButton.setImage(nil, for: .normal)
            checkBool = false
        } else{
            checkButton.setImage(UIImage(named: "check"), for: .normal)
            checkBool = true
        }
    }
}



