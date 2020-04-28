//
//  CustomTableViewCell.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/26.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var iconImageView = UIImageView()
    var userName = UILabel()
    var userID = UILabel()
    var contentLabel = UILabel()
    var contentPic = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        /*
        if let name = userName.text {
            print(name)
        }
        */

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(userName)
        contentView.addSubview(userID)
        contentView.addSubview(contentPic)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.frame = CGRect(x: 20, y: 20, width: 60, height: 60)
        iconImageView.layer.cornerRadius = 30
        //iconImageView.backgroundColor = .gray
        iconImageView.clipsToBounds = true
        
        userName.frame = CGRect(x: 100, y: 0, width: self.frame.width - 100, height: 30)
        
        userID.frame = CGRect(x: 100, y: 30, width: self.frame.width - 100, height: 20)
        userID.textColor = .gray
        
        contentLabel.frame = CGRect(x: 100, y: 50, width: self.frame.width - 100, height: 75)
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        //contentLabel.backgroundColor = .gray
        
        //contentPic.frame = CGRect(x: 100, y: 125, width: self.frame.width - 100, height: 175)
        //contentPic.backgroundColor = .gray
    }
    
    func setCell(name: String, id: String, content: String?, iconImage: UIImage/*, contentImage: Favorite.Extended_entities?*/) {
        iconImageView.image = iconImage
        userName.text = name
        userID.text = id
        if let content = content {
            contentLabel.text = content
        } else {
            print("error")
            contentLabel.text = ""
        }
        
        
        /*
        if let image = contentImage {
            contentPic.frame = CGRect(x: 100, y: 125, width: self.frame.width - 100, height: 175)
            contentPic.image = UIImage(url: image.media[0].media_url_https)
        }
        */
    }
}



