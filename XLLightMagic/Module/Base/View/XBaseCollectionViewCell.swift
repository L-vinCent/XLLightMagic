//
//  XBaseCollectionViewCell.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/25.
//

import Reusable

class XBaseCollectionViewCell: UICollectionViewCell, Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configUI() {}
}
