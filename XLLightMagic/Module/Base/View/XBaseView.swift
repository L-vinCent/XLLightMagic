//
//  XBaseView.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/24.
//

import UIKit

class XBaseView : UIView {
    
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.themeBackground
        configUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {}
        
}
