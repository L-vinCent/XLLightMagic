//
//  XHomeBannerView.swift
//  XLLightMagic
//
//  Created by admin on 2024/4/2.
//

import Foundation
import UIKit
import LLCycleScrollView

class XHomeBannerView:XBaseView {
        
    private lazy var imagesURLStrings:[String] = {
        return [
            "bg_home_banner.png",
            "bg_home_banner.png",
        ]
    }()
    
    private lazy var bannerView:LLCycleScrollView = {
        let banner = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.zero)
        banner.autoScrollTimeInterval = 5.0
        banner.imagePaths = self.imagesURLStrings
        banner.layer.masksToBounds = true
        banner.layer.cornerRadius = 10
        return banner
    }()
    
    override func configUI() {
        addSubview(self.bannerView)
        
        bannerView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
    }
    
    
}
