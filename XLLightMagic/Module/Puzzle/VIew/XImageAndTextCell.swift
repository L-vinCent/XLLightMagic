//
//  TYOprationCell.swift
//  TYPictureMaker
//
//  Created by Sheldon Tian on 2023/5/22.
//

import UIKit

class XImageAndTextCell: XBaseCollectionViewCell {
    var text : String? {
        didSet {
            textLbl.text = text
        }
    }
    
    var image : UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var selectedImage : UIImage?
    
    private lazy var textLbl : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.normalTextColor
        lbl.font = UIFont.regularFont
        lbl.textAlignment = .center
        contentView.addSubview(lbl)
        return lbl
    }()
    
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        return imageView
    }()
    
    override func configUI() {
        
        textLbl.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.height.greaterThanOrEqualTo(10)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(textLbl.snp.top).offset(-4)
        }
    }
    
    
    override var isSelected: Bool {
        didSet {
            if (isSelected) {
                textLbl.textColor = UIColor.selectColor
                if let selectedImage = selectedImage {
                    imageView.image = selectedImage
                } else {
                    imageView.image = image
                }
            } else {
                textLbl.textColor = UIColor.normalTextColor
                imageView.image = image
            }
        }
    }
    
}
