//
//  XBoardLayoutCell.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/25.
//

import UIKit

class XBoardLayoutCell:XBaseCollectionViewCell{
        
    var image:UIImage?{
        didSet{
            self.imageView.image = image
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if (isSelected) {
                imageView.layer.borderColor = UIColor.red.cgColor
                imageView.layer.borderWidth = 2.0
            } else {
                imageView.layer.borderColor = UIColor.clear.cgColor
                imageView.layer.borderWidth = 0.0
            }
        }
    }
    
    private lazy var imageView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    
    override func configUI() {
        contentView.addSubview(self.imageView)
        
        imageView.snp_makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(45)
            make.center.equalToSuperview()
        }
    }
    
    
    
}
