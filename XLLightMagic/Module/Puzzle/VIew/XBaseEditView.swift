//
//  XBaseEditView.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/24.
//

import UIKit

class XBaseEditView: UIView {
    
    // 图片集
    var images : [UIImage]?
    
    // 背景图片
    var backgroundImage : UIImage? {
        didSet {
            if let image = backgroundImage {
                backgroundImageView.image = image
            }
        }
    }
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // 边框图片
    var frameImage: UIImage? {
        didSet {
            if let image = frameImage {
                frameImageView.image = image
                contentView.snp.remakeConstraints { make in
                    make.edges.equalToSuperview().inset(UIEdgeInsets(top: padding + 4, left: padding + 4, bottom: padding + 4, right: padding + 4))
                }
            } else {
                contentView.snp.remakeConstraints { make in
                    make.edges.equalToSuperview().inset(UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
                }
            }
        }
    }
    
    // 图片间距
    var imagePandding: CGFloat = 4
    
    // 图片圆角
    var imageCornerRadio : CGFloat = 4
//}
//        didSet {
//            contentView.subviews.forEach { subview in
//                if subview.isKind(of: XImageEditView.self) {
//                    let view = subview as! XImageEditView
//                    view.cornerRaido = imageCornerRadio
//                }
//            }
//        }
//    }
    
    // 边框图片视图
    private lazy var frameImageView : UIImageView = {
        let imageView = UIImageView(image: frameImage)
        return imageView
    }()
    
    // 保存内容的视图
    lazy var contentView : UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    var padding : CGFloat = 4 {
        didSet {
            contentView.snp.remakeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    convenience init(images:[UIImage]?) {
        self.init()
        self.images = images
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
//        addSubview(frameImageView)
//        addSubview(backgroundImageView)
//        addSubview(contentView)
//        frameImageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        backgroundImageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview().inset(UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
//        }
//        contentView.snp.makeConstraints { make in
//            make.edges.equalTo(backgroundImageView)
//        }
    }

}
