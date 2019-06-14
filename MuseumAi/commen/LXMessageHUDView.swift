//
//  LXMessageHUDView.swift
//  lexiwed2
//
//  Created by Kyle on 2017/9/23.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

import UIKit

class LXMessageHUDView: KYBaseContentView {

    // MARK: - Appearance

    /// The font and size of the title label



    @objc public dynamic var messageFont: UIFont {
        get { return messageLabel.font }
        set { messageLabel.font = newValue }
    }

    /// The color of the title label
    @objc public dynamic var messageColor: UIColor? {
        get { return messageLabel.textColor }
        set { messageLabel.textColor = newValue }
    }

    /// The text alignment of the title label
    @objc public dynamic var messageTextAlignment: NSTextAlignment {
        get { return messageLabel.textAlignment }
        set { messageLabel.textAlignment = newValue }
    }


    /// The view that will contain the image, if set

    /// The title label of the dialog
    internal lazy var iconView: UIImageView = {
        let titleLabel = UIImageView(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    internal lazy var messageLabel: UILabel = {
        let messageLabel = UILabel(frame: .zero)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor(red: 153.0, green: 153.0, blue: 153.0, alpha: 1.0)
        messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return messageLabel
    }()




    /// The height constraint of the image view, 0 by default

    internal var image : UIImage!
    internal var message : String!

    @objc init( image: UIImage,
          message: String){
        self.image = image
        self.message = message
        super.init(frame:.zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View setup

    internal override func setupViews() {
        // Self setup
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true

        // Add views
        addSubview(iconView)
        addSubview(messageLabel)


        iconView.image = self.image
        messageLabel.text = self.message

        // Layout views
        let views = ["iconView": iconView,"messageLabel":messageLabel] as [String : Any]
        var constraints = [NSLayoutConstraint]()


        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==20@900)-[messageLabel]-(==20@900)-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[iconView]-18-[messageLabel]-30-|", options: [], metrics: nil, views: views)
       constraints.append(NSLayoutConstraint(item: iconView, attribute: .centerX   , relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: self, attribute: .width   , relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0.0, constant: 200))
         constraints.append(NSLayoutConstraint(item: self, attribute: .height   , relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0.0, constant: 110))
        // Activate constraints
        NSLayoutConstraint.activate(constraints)
    }

}
